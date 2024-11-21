import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/notes_data.dart';
import 'package:myapp/auth/notes_firestore.dart';
import 'package:myapp/pages/edit_page.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(
      {super.key,
      required int index,
      required int extent,
      required this.title,
      required this.content,
      required this.titleController,
      required this.contentController,
      required this.noteService,
      required this.noteId});
  final String title;
  final String content;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final NoteService noteService;
  final String noteId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditPage(
                  noteId: noteId,
                  noteService: noteService,
                  contentController: contentController,
                  onNoteSaved: () {
                    Navigator.pop(context);
                  },
                  titleController: titleController,
                )));
      },
      onLongPress: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[400],
            content: Row(
              children: [
                const Text(
                  'Files deleted will be permanently removed',
                  style: TextStyle(color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      Timestamp timestamp = Timestamp.now();
                      Notes noteToDelete = Notes(
                          id: noteId,
                          title: title,
                          content: content,
                          timestamp: timestamp);
                      noteService.deleteTasks(noteToDelete);
                    },
                    icon:
                        const Icon(Icons.delete, color: Colors.black, size: 20))
              ],
            )));
      },
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
