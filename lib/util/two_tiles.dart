import 'package:flutter/material.dart';

class TwoTiles extends StatefulWidget {
  const TwoTiles(
      {super.key,
      required this.titleController,
      required this.contentController});
  final TextEditingController titleController;
  final TextEditingController contentController;

  @override
  State<TwoTiles> createState() => _TwoTilesState();
}

class _TwoTilesState extends State<TwoTiles> {
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    titleFocusNode.dispose();
    contentFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.titleController,
          focusNode: titleFocusNode,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ),
        Divider(
          height: 1,
          color: Colors.grey[600],
        ),
        TextField(
          controller: widget.contentController,
          focusNode: contentFocusNode,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Content',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[700])),
          maxLines: null,
        ),
      ],
    );
  }
}
