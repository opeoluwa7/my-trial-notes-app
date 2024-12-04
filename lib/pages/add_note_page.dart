import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/note_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:myapp/util/two_tiles.dart';
import 'package:provider/provider.dart';

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
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    titleFocusNode.dispose();
    contentFocusNode.dispose();
  }

  void onAddNote() async {
    String noteId = FirebaseFirestore.instance.collection("Notes").doc().id;
    Timestamp timestamp = Timestamp.now();
    NoteModel notes = NoteModel(
        id: noteId,
        title: titleController.text,
        content: contentController.text,
        timestamp: timestamp);
    try {
      FocusScope.of(context).unfocus();
      await context.read<DbProvider>().createNote(notes, currentUser!.uid);
      titleController.clear();
      contentController.clear();
      widget.onNoteSaved();
    } catch (e) {
      rethrow;
    }
  }

  void onExit() {
    widget.onNoteSaved();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('This was tapped');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _appBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            height: 1,
            color: Colors.grey[600],
          ),
        ),
        _twoTiles()
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      title: const Text(
        'Add a new note',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      automaticallyImplyLeading: true,
      centerTitle: true,
      actions: [
        IconButton(onPressed: onExit, icon: const Icon(Icons.close)),
        IconButton(
            onPressed: onAddNote, icon: const Icon(Icons.save_alt_outlined)),
      ],
    );
  }

  Widget _twoTiles() {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TwoTiles(
        titleController: titleController,
        contentController: contentController,
      ),
    ));
  }
}
