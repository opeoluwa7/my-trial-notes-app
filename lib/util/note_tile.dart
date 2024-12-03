import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/note_model.dart';
import 'package:myapp/pages/edit_page.dart';
import 'package:myapp/providers/db_provider.dart';

class NoteTile extends StatelessWidget {
  NoteTile(
      {super.key,
      required int index,
      required int extent,
      required this.title,
      required this.content,
      required this.titleController,
      required this.contentController,
      required this.noteId,
      required this.note});
  final String title;
  final String content;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String noteId;
  final NoteModel note;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future onTapFunction(context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPage(
          noteId: noteId,
          contentController: contentController,
          onNoteSaved: () {
            Navigator.pop(context);
          },
          titleController: titleController,
        ),
      ),
    );
  }

  void deleteNote(context) {
    context.read<DbProvider>().deleteNote(currentUser!.uid, noteId, note);
  }

  void lpFunction(context)  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[400],
        content: Row(
          children: [
            const Text(
              'Files deleted will be permanently removed',
              style: TextStyle(color: Colors.black),
            ),
            IconButton(
                onPressed: () => deleteNote(context),
                icon: const Icon(Icons.delete, color: Colors.black, size: 20))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapFunction(context),
      onLongPress: () => lpFunction(context),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8)),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
