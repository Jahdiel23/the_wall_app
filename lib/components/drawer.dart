import 'package:flutter/material.dart';
import 'package:the_wall_app/components/my_liste_title.dart'; // Importación del componente MyListTitle.

/// Widget que representa un menú lateral (Drawer) con opciones.
class MyDrawer extends StatelessWidget {
  // Funciones que se ejecutarán al seleccionar las opciones de perfil y cerrar sesión.
  final void Function()? onTapProfile;
  final void Function()? onTapLogout;

  /// Constructor para inicializar las acciones de perfil y logout.
  const MyDrawer({
    super.key, 
    required this.onTapLogout, 
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black, // Fondo negro para el Drawer.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribución del contenido.
        children: [
          Column(
            children: [
              // Encabezado del Drawer.
              const DrawerHeader(
                child: Icon(
                  Icons.person, // Icono de perfil.
                  color: Colors.white, // Color blanco para el icono.
                  size: 64, // Tamaño del icono.
                ),
              ),

              // Opción para ir a la página principal.
              MyListTitle(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context), // Cierra el Drawer.
              ),

              // Opción para ir al perfil.
              MyListTitle(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: onTapProfile, // Llama a la función proporcionada.
              ),
            ],
          ),

          // Opción para cerrar sesión, ubicada en la parte inferior.
          Padding(
            padding: const EdgeInsets.only(bottom: 25), // Espaciado inferior.
            child: MyListTitle(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: onTapLogout, // Llama a la función proporcionada.
            ),
          ),
        ],
      ),
    );
  }
}