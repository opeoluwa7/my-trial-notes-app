import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/notes_data.dart';
import 'package:myapp/auth/notes_firestore.dart';
import 'package:myapp/util/two_tiles.dart';

class EditPage extends StatefulWidget {
  EditPage(
      {super.key,
      required this.onNoteSaved,
      required this.titleController,
      required this.contentController,
      required this.noteService,
      required this.noteId});
  final VoidCallback onNoteSaved;
  final NoteService noteService;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String noteId;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void dispose() {
    widget.contentController.dispose();
    widget.titleController.dispose();
    super.dispose();
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
                      onPressed: () async {
                        Timestamp timestamp = Timestamp.now();
                        Notes notes = Notes(
                            id: widget.noteId,
                            title: widget.titleController.text,
                            content: widget.contentController.text,
                            timestamp: timestamp);
                        try {
                          await widget.noteService.updateNotes(notes);
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
