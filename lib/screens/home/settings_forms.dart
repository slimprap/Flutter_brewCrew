import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/my_user.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:flutter_firebase/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String? _currentName;
  String? _currentSugars;
  dynamic _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Update your brew settings',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration,
                    validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                    onChanged: (val) {
                      setState(() => _currentName = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  // drop down
                  DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentSugars ?? userData?.sugars,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text('$sugar sugars'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentSugars = val)),
                  // slider
                  Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value:
                          (_currentStrength ?? userData?.strength).toDouble(),
                      activeColor:
                          Colors.brown[_currentStrength ?? userData?.strength],
                      inactiveColor:
                          Colors.brown[_currentStrength ?? userData?.strength],
                      onChanged: (val) =>
                          setState(() => _currentStrength = val.round())),
                  ElevatedButton(
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user?.uid).updateUserData(
                              _currentSugars ?? userData?.sugars ?? '0',
                              _currentName ?? userData?.name ?? '',
                              _currentStrength ?? userData?.strength ?? 100);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
