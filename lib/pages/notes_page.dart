import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myapp/auth/notes_data.dart';
import 'package:myapp/auth/notes_firestore.dart';
import 'package:myapp/util/note_tile.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({
    super.key,
    required this.noteService,
  });
  final NoteService noteService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: noteService.fetchNotes(),
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
                    var note = Notes.fromMap(
                      notes[index].data() as Map<String, dynamic>,
                      notes[index].id,
                    );
                    TextEditingController contentController =
                        TextEditingController(text: note.content);
                    TextEditingController titleController =
                        TextEditingController(text: note.title);
                        
                    return NoteTile(
                      noteId: note.id,
                      noteService: noteService,
                      contentController: contentController,
                      titleController: titleController,
                      index: index,
                      extent: (index % 5 + 1) * 100,
                      title: note.title,
                      content: note.content,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No notes found'),
                );
              }
            }));
  }
}
