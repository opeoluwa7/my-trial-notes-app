// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_service.dart';
import 'package:myapp/auth/users_data.dart';

class BaseAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService firestoreService = FirestoreService();

  //to sign in
  Future signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      rethrow;
    }
  }

  //to sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  //to create user
  Future createUser(
      String email, String password, String firstName, String lastName) async {
    try {
      //create user in firebase auth
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //create userdata object
      UserData userData =
          UserData(email: email, firstName: firstName, lastName: lastName);

      //add user profile data to firestore database
      await firestoreService.addUser(userData);
    } on FirebaseAuthException catch (e) {
      print('Process failed because $e');
      rethrow;
    }
  }

  // delete account
  Future deleteUser() async {
    final uid = auth.currentUser!.uid;
      //this deletes the actual user account from firebase auth
      await auth.currentUser!.delete();

      await firestoreService.deleteProfileData(uid);
  }
}
