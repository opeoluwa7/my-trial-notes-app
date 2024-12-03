// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(child: _buildBody(
        context
      )),
    );
  }

  void clearDialog(context) {
    Navigator.pop(context);
  }

  Widget _buildBody(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Are you sure you want to delete your account?'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () => clearDialog(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: onPressed,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        )
      ],
    );
  }
}
