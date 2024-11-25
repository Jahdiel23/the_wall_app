import 'package:flutter/material.dart';

/// A customizable text field widget with options for hint text,
/// obscured text (for passwords), and controller management.
class MyTextField extends StatelessWidget {
  /// The controller for managing text input.
  final TextEditingController controller;

  /// The placeholder text displayed when the field is empty.
  final String hintText;

  /// Whether to obscure the text input (e.g., for passwords).
  final bool obscureText;

  /// Creates a customizable text field widget.
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Controller to handle the text input.
      controller: controller,

      // Determines whether the text is obscured.
      obscureText: obscureText,

      // Input decoration with customizable border and style.
      decoration: InputDecoration(
        // Border when the text field is not focused.
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),

        // Border when the text field is focused.
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        // Background color of the text field.
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,

        // Hint text displayed inside the field.
        hintText: hintText,

        // Styling for the hint text.
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
      ),
    );
  }
}