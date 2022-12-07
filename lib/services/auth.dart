import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/my_user.dart';
import 'package:flutter_firebase/services/database.dart';

class AuthService {
  // starting with _ mean, it is private
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on User
  MyUser? _userFromUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromUser);
    //.map((User? user) => _userFromUser(user)); <-- same thing as the top
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUser(user!);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user?.uid)
          .updateUserData('0', 'new member', 100);
      return _userFromUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
