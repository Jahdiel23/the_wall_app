import 'package:flutter/material.dart'; 
// Importa Flutter para construir la interfaz de usuario.

class MyListTitle extends StatelessWidget { 
  // Define un widget sin estado (stateless) para representar un elemento de lista.

  final IconData icon; 
  // Propiedad que especifica el ícono que se mostrará en el elemento.

  final String text; 
  // Propiedad que especifica el texto que se mostrará junto al ícono.

  final void Function()? onTap; 
  // Callback opcional que se ejecutará cuando el usuario toque el elemento.

  MyListTitle({
    super.key, 
    required this.icon, 
    required this.text, 
    required this.onTap,
  }); 
  // Constructor que requiere el ícono, el texto y el callback `onTap`.

  @override
  Widget build(BuildContext context) {
    // Método que construye el widget.

    return Padding(
      // Envuelve el elemento `ListTile` con un padding a la izquierda.

      padding: const EdgeInsets.only(left: 10.0), 
      // Agrega un margen izquierdo de 10 píxeles al contenido.

      child: ListTile(
        // Componente que representa un elemento de lista interactivo.

        leading: Icon(
          icon, 
          // Muestra el ícono proporcionado en la propiedad `icon`.

          color: Colors.white, 
          // Cambia el color del ícono a blanco.
        ),

        onTap: onTap, 
        // Ejecuta la función proporcionada en `onTap` cuando se presiona el elemento.

        title: Text(
          text, 
          // Muestra el texto proporcionado en la propiedad `text`.

          style: TextStyle(
            color: Colors.grey, 
            // El texto se muestra en color gris.

            fontSize: 16, 
            // Tamaño de la fuente del texto.
          ),
        ),
      ),
    );
  }
}