import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/shared/constants.dart';

import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Sign In to Brew Crew'),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('Register')),
              ],
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val!.length < 6
                              ? "Enter a password 6+ chars long"
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Please use a valid email/password';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: const Text('Sign in',
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        Text(error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14)),
                      ],
                    ))));
  }
}
