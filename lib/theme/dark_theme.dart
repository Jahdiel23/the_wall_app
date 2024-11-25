import 'package:flutter/material.dart';

/// Configuración del tema oscuro para la aplicación.
ThemeData darkTheme = ThemeData(
  // Brillo del tema: oscuro.
  brightness: Brightness.dark,

  // Configuración del AppBar.
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // Fondo negro para la barra de la aplicación.
  ),

  // Configuración de la paleta de colores.
  colorScheme: ColorScheme.dark(
    surface: Colors.black,       // Color de las superficies.
    primary: Colors.grey[900]!,  // Color principal.
    secondary: Colors.grey[800]!, // Color secundario.
  ),

  // Configuración para botones de texto.
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white, // Texto blanco en los botones de texto.
    ),
  ),
);