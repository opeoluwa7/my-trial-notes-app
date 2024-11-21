import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton(
      {super.key,
      this.onPressed,
      required this.text,
      required this.icon,
      required this.size, required this.color, required this.iconColor});

  final void Function()? onPressed;
  final String text;
  final IconData icon;
  final double size;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
     // margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: color),
            ),
          ),
          Icon(
            icon,
            size: size,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
