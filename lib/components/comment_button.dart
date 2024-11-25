import 'package:flutter/material.dart';

/// Un botón de comentarios reutilizable en Flutter.
class CommentButton extends StatelessWidget {
  /// Función que se ejecuta cuando el botón es presionado.
  final void Function()? onTap;

  /// Constructor del botón de comentarios, requiere una función `onTap`.
  const CommentButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta el toque del usuario y ejecuta la función `onTap`.
      onTap: onTap,
      child: const Icon(
        Icons.comment, // Icono de comentario.
        color: Colors.grey, // Color gris para el icono.
      ),
    );
  }
}