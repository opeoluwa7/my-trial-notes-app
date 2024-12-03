import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/note_model.dart';
import 'package:myapp/models/user_model.dart';

class DbProvider extends ChangeNotifier {
  final users = FirebaseFirestore.instance.collection('users');

  //to update user info in the database
  Future<UserModel?> fetchUserData(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await users.doc(userId).collection('userInfo').doc('info').get();

    if (snapshot.exists) {
      final Map<String, dynamic> userData =
          snapshot.data() as Map<String, dynamic>;
      return UserModel.fromMap(userData);
    } else {
      return null;
    }
  }

  Future updateUserInfo(UserModel user, String userId) async {
    final userInfo = await users
        .doc(userId)
        .collection('userInfo')
        .doc('info')
        .update(user.toMap());
    return userInfo;
  }

  Future deleteUserInfo(String userId, Function deleteUserCallback) async {
    /*await users.doc(userId).collection('userInfo').doc('info').delete();
    await users.doc(userId).collection('notes').doc().delete();*/

    // this deletes the user Info sub collection
    final userCollection = users.doc(userId).collection('userInfo');
    final userDoc = await userCollection.get();
    for (var doc in userDoc.docs) {
      await doc.reference.delete();
    }

    // this deletes the notes collection
    final notesCollection = users.doc(userId).collection('notes');
    final notesDoc = await notesCollection.get();
    for (var doc in notesDoc.docs) {
      await doc.reference.delete();
    }

    //this deletes the main document
    await users.doc(userId).delete();

    // this method is later called in the profile page where I assigned the delete user method
    deleteUserCallback();

    notifyListeners();

    //this deletes the user account from firebase authentication
    // I did not use this method because of the build synchronosly method, that does not mean it is wrong, it did not just apply to this situation in my case
    //await context.read<Auth>().deleteUser();
  }

  //------------------------------------------------------------------------

  //FOR NOTES

  //to create a note
  Future createNote(NoteModel note, String userId) async {
    final noteId = users.doc(userId).collection('notes').doc().id;
    final newNote = note.copyWith(id: noteId);
    final noteData = await users
        .doc('userId')
        .collection('notes')
        .doc(noteId)
        .set(newNote.toMap());
    notifyListeners();
    return noteData;
  }

  Stream<QuerySnapshot> fetchNotes(String userId) {
    try {
      final noteStream = users.doc(userId).collection('notes').snapshots();
      return noteStream;
    } catch (e) {
      rethrow;
    }
  }

  Future updateNotes(String userId, String noteId, NoteModel note) async {
    await users
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update(note.toMap());
    notifyListeners();
  }

  void deleteNote(String userId, String noteId, NoteModel note) async {
    await users.doc(userId).collection('notes').doc(noteId).delete();
  }
}
