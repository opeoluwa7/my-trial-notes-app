import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/notes_data.dart';
import 'package:myapp/auth/notes_firestore.dart';
import 'package:myapp/util/two_tiles.dart';

class AddNotePage extends StatefulWidget {
  final VoidCallback onNoteSaved;
  const AddNotePage({
    super.key,
    required this.onNoteSaved,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final NoteService noteService = NoteService();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('This was tapped');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text(
                'Add a new note',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              automaticallyImplyLeading: true,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      widget.onNoteSaved();
                    },
                    icon: const Icon(Icons.close)),
                IconButton(
                    onPressed: () async {
                      String noteId = FirebaseFirestore.instance
                          .collection("Notes")
                          .doc()
                          .id;
                      Timestamp timestamp = Timestamp.now();
                      Notes notes = Notes(
                          id: noteId,
                          title: titleController.text,
                          content: contentController.text,
                          timestamp: timestamp);
                      try {
                        await noteService.addNotes(notes);
                        widget.onNoteSaved();
                      } catch (e) {
                        rethrow;
                      }
                    },
                    icon: const Icon(Icons.save_alt_outlined)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 1,
                color: Colors.grey[600],
              ),
            ),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TwoTiles(
                titleController: titleController,
                contentController: contentController,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
