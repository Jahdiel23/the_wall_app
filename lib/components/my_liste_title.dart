import 'package:flutter/material.dart';

class MyListTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MyListTitle({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
