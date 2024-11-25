import 'package:flutter/material.dart';

/// Un botón personalizado reutilizable en Flutter.
class MyButton extends StatelessWidget {
  /// Función que se ejecuta cuando el botón es presionado.
  final Function()? onTap;

  /// Texto que se muestra dentro del botón.
  final String text;

  /// Constructor del botón, requiere la función `onTap` y el texto `text`.
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta el toque del usuario y ejecuta la función `onTap`.
      onTap: onTap,
      child: Container(
        // Espaciado interno del botón.
        padding: const EdgeInsets.all(25),
        // Decoración del botón, incluyendo color de fondo y bordes redondeados.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Bordes redondeados.
          color: Colors.black, // Color de fondo del botón.
        ),
        child: Center(
          // Alineación del texto en el centro del botón.
          child: Text(
            text, // Texto del botón proporcionado por el usuario.
            style: const TextStyle(
              color: Colors.white, // Color del texto.
              fontWeight: FontWeight.bold, // Negrita para resaltar el texto.
              fontSize: 15, // Tamaño del texto.
            ),
          ),
        ),
      ),
    );
  }
}