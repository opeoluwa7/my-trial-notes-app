import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myapp/models/note_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:myapp/util/note_tile.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      body: NotesStreamBody(),
    );
  }
}

class NotesStreamBody extends StatelessWidget {
  NotesStreamBody({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.watch<DbProvider>().fetchNotes(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('There seems to be an error'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> notes = snapshot.data!.docs;
          return MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = NoteModel.fromMap(
                notes[index].data() as Map<String, dynamic>,
              );
              TextEditingController contentController =
                  TextEditingController(text: note.content);
              TextEditingController titleController =
                  TextEditingController(text: note.title);

              return _buildNoteTile(
                note,
                index,
                titleController,
                contentController,
              );
            },
          );
        } else {
          return const Center(
            child: Text('No notes found'),
          );
        }
      },
    );
  }

  Widget _buildNoteTile(NoteModel note, int index, TextEditingController titleController, TextEditingController contentController) {
    return NoteTile(
      note: note,
      noteId: note.id,
      contentController: contentController,
      titleController: titleController,
      index: index,
      extent: (index % 5 + 1) * 100,
      title: note.title,
      content: note.content,
    );
  }
}
