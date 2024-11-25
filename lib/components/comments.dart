import 'package:flutter/material.dart';

/// Widget que representa un comentario en una publicación o sección de comentarios.
class Comment extends StatelessWidget {
  /// Texto del comentario.
  final String text;

  /// Usuario que realizó el comentario.
  final String user;

  /// Tiempo en que se realizó el comentario.
  final String time;

  /// Constructor que recibe el texto, usuario y tiempo del comentario.
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Estiliza el contenedor del comentario.
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary, // Color del tema.
        borderRadius: BorderRadius.circular(4), // Bordes redondeados.
      ),
      margin: const EdgeInsets.only(bottom: 5), // Espaciado inferior.
      padding: const EdgeInsets.all(15), // Espaciado interno.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido al inicio.
        children: [
          // Texto del comentario.
          Text(text),

          const SizedBox(height: 5), // Espaciado entre texto y detalles.

          // Usuario y tiempo del comentario.
          Row(
            children: [
              // Nombre del usuario.
              Text(
                user,
                style: TextStyle(color: Colors.grey[400]), // Estilo gris claro.
              ),

              // Separador entre usuario y tiempo.
              Text(
                " . ", // Punto separador.
                style: TextStyle(color: Colors.grey[400]),
              ),

              // Tiempo del comentario.
              Text(
                time,
                style: TextStyle(color: Colors.grey[400]), // Estilo gris claro.
              ),
            ],
          ),
        ],
      ),
    );
  }
}