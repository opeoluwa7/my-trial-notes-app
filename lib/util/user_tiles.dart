import 'package:flutter/material.dart';

class UserTiles extends StatelessWidget {
  const UserTiles({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        titleTextStyle: TextStyle(color: Colors.grey[400]),
        title: Text(
          text,
          style: const TextStyle(
            wordSpacing: 100,
          ),
        ),
      ),
    );
  }
}
