import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    required this.press,
    required this.color,
  });

  final String text;
  final IconData icon;
  final VoidCallback press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          backgroundColor: WidgetStateProperty.all(const Color(0xFFF5F6F9)),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}
