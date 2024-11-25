import 'package:flutter/material.dart'; 
// Importa Flutter para construir la interfaz de usuario.

class LikeButton extends StatelessWidget { 
  // Define un widget sin estado (stateless) para el botón de "Me gusta".

  final bool isLiked; 
  // Propiedad que indica si el botón está en estado "me gusta" o no.

  final void Function()? onTap; 
  // Callback opcional que se ejecuta cuando se presiona el botón.

  const LikeButton({super.key, required this.isLiked, required this.onTap}); 
  // Constructor que requiere las propiedades `isLiked` y `onTap`.

  @override
  Widget build(BuildContext context) {
    // Método que construye el widget.

    return GestureDetector(
      // Widget que detecta gestos del usuario, como toques.

      onTap: onTap, 
      // Cuando el botón se presiona, se ejecuta la función proporcionada en `onTap`.

      child: Icon(
        // Muestra un ícono visual según el estado.

        isLiked ? Icons.favorite : Icons.favorite_border, 
        // Si `isLiked` es verdadero, muestra un corazón lleno; de lo contrario, un corazón vacío.

        color: isLiked ? Colors.red : Colors.grey, 
        // Cambia el color del ícono: rojo si está "me gusta", gris si no.
      ),
    );
  }
}