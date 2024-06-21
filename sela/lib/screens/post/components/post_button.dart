import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PostButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Text(text),
    );
  }
}
