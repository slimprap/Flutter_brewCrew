import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/brew.dart';
import 'package:flutter_firebase/screens/home/brew_list.dart';
import 'package:flutter_firebase/screens/home/settings_forms.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/services/database.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    minimumSize: const Size(88, 44),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: const SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService().brews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0,
          actions: [
            TextButton.icon(
                style: flatButtonStyle,
                onPressed: () => _showSettingsPanel(),
                icon: const Icon(Icons.settings),
                label: const Text('settings')),
            TextButton.icon(
                style: flatButtonStyle,
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: const Icon(Icons.person),
                label: const Text('logout')),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/coffee_bg.png'),
                    fit: BoxFit.cover)),
            child: const BrewList()),
      ),
    );
  }
}
