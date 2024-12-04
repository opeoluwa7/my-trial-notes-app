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

class NotesStreamBody extends StatefulWidget {
  const NotesStreamBody({super.key});

  @override
  State<NotesStreamBody> createState() => _NotesStreamBodyState();
}

class _NotesStreamBodyState extends State<NotesStreamBody> {
  String? userId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.watch<DbProvider>().fetchNotes(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          List<NoteModel> notes = snapshot.data!.docs
              .map((doc) =>
                  NoteModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          return MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = NoteModel.fromMap(
                notes[index] as Map<String, dynamic>,
              );
              final contentController =
                  TextEditingController(text: note.content);
              final titleController = TextEditingController(text: note.title);

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

  Widget _buildNoteTile(
      NoteModel note,
      int index,
      TextEditingController titleController,
      TextEditingController contentController) {
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
