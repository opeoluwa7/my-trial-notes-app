import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/auth/notes_data.dart';

class NoteService {
  CollectionReference notes = FirebaseFirestore.instance.collection("Notes");

  //to add notes
  Future<void> addNotes(Notes note) async {
    Map<String, dynamic> noteData = note.toMap();
    await notes.add(noteData);
  }

  //to read notes
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchNotes() {
    try {
      final noteStream = notes
          .orderBy('timestamp', descending: true)
          .snapshots()
          .cast<QuerySnapshot<Map<String, dynamic>>>();
      return noteStream;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching notes: $e');
      rethrow;
    }
  }

  //to update notes
  Future<void> updateNotes(Notes note) async {
    return notes.doc(note.id).update(note.toMap());
  }

  //to delete tasks
  Future<void> deleteTasks(Notes note) {
    return notes.doc(note.id).delete();
  }
}
