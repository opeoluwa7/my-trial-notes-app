import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onPressed, required this.text, required this.color, required this.padding, required this.textColor});
  final void Function() onPressed;
  final String text;
  final Color color;
  final EdgeInsetsGeometry padding;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: Colors.white, width: 2, style: BorderStyle.solid),
      ),
      child: Padding(
        padding: padding,
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
