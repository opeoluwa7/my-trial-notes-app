import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/users_data.dart';

class FirestoreService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // to add users
  Future<void> addUser(UserData user) async {
    //convert the userdata object into a map
    Map<String, dynamic> userData = user.toMap();

    await users.add(userData);
  }

  //get the users data from firebase
  Future<UserData?> fetchUserData(String userId) async {
    //this gets each doc data
    DocumentSnapshot snapshot = await users.doc(userId).get();

    if (snapshot.exists) {
      //because the doc exists as a map, it must be gotten back as well the same way before it can be converted
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      //this creates an object that can be used to store the data gotten from firebase
      UserData userData = UserData.fromMap(data);
      //this returns the object so it can be displayed and used
      return userData;
    } else {
      return null;
    }
  }

  //update profile data in firestore
  Future updateProfileData(UserData userData) async {
    final userDoc = FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser!.uid);

    await userDoc.update(userData.toMap());
  }

  //delete from firestore
  Future deleteProfileData(String userId) async {
    try {
      await users.doc(userId).delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }
}
