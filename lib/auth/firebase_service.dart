import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/users_data.dart';

class FirestoreService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // to add users
  Future<void> addUser(UserData user) async {
    final currentUser = auth.currentUser;
  if (currentUser != null) {
    // Convert the UserData object into a map
    Map<String, dynamic> userData = user.toMap();

    // Use the Firebase Auth UID as the document ID
    await users.doc(currentUser.uid).set(userData);
  }
  }

  //get the users data from firebase
  Future<UserData?> fetchUserData(String userId) async {
    final DocumentSnapshot documentSnapshot = await users.doc(userId).get();

  if (documentSnapshot.exists) {
    // Map the document data to the UserData object
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserData.fromMap(data);
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
