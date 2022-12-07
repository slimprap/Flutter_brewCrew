import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/my_user.dart';
import 'package:flutter_firebase/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    //return either home or authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
