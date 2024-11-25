import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  // Este es un botón personalizado que muestra un ícono de eliminar (cancelar).

  final void Function()? onTap; 
  // Callback que se ejecutará cuando se toque el botón.

  const DeleteButton({super.key, required this.onTap}); 
  // Constructor que recibe la función `onTap`.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta gestos táctiles en el widget.

      onTap: onTap, 
      // Ejecuta la función `onTap` cuando el usuario toca el botón.

      child: const Icon(
        // Ícono que se muestra como botón.
        Icons.cancel, 
        // Representa un ícono de cancelación o eliminación.

        color: Colors.grey, 
        // El color gris indica una acción secundaria o no principal.
      ),
    );
  }
}