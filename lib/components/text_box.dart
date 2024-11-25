import 'package:flutter/material.dart';

/// Widget que representa una caja de texto con un título, texto y un botón de configuración.
class MyTextBox extends StatelessWidget {
  // Texto principal que se muestra en la caja.
  final String text;
  // Nombre de la sección que se mostrará como encabezado.
  final String sectionName;
  // Función que se ejecuta al presionar el botón de configuración.
  final void Function()? onPressed;

  /// Constructor del widget.
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Estilo y diseño de la caja de texto.
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary, // Color de fondo basado en el tema.
        borderRadius: BorderRadius.circular(8), // Bordes redondeados.
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15), // Espaciado interno.
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20), // Espaciado externo.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido al inicio.
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaciado entre título y botón.
            children: [
              // Nombre de la sección.
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]), // Estilo del texto del encabezado.
              ),

              // Botón de configuración.
              IconButton(
                onPressed: onPressed, // Acción al presionar.
                icon: Icon(
                  Icons.settings, // Icono de configuración.
                  color: Colors.grey[400], // Color del icono.
                ),
              ),
            ],
          ),

          // Texto principal (contenido de la sección).
          Text(
            text,
            style: const TextStyle(fontSize: 16), // Tamaño del texto.
          ),
        ],
      ),
    );
  }
}