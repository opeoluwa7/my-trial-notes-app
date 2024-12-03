import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/note_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:myapp/util/two_tiles.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  EditPage(
      {super.key,
      required this.onNoteSaved,
      required this.titleController,
      required this.contentController,
      required this.noteId});
  final VoidCallback onNoteSaved;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String noteId;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    widget.contentController.dispose();
    widget.titleController.dispose();
    super.dispose();
  }

  Future<void> updateNotes() async {
    Timestamp timestamp = Timestamp.now();
    NoteModel notes = NoteModel(
        id: widget.noteId,
        title: widget.titleController.text,
        content: widget.contentController.text,
        timestamp: timestamp);
    try {
      await context
          .read<DbProvider>()
          .updateNotes(currentUser!.uid, notes.id, notes);
      widget.onNoteSaved();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
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
                  'Edit note',
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
                      onPressed: updateNotes,
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
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TwoTiles(
                    titleController: widget.titleController,
                    contentController: widget.contentController,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
