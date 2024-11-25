import 'package:flutter/material.dart';

/// Tema claro de la aplicación.
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light, // Define el tema como claro.

  /// Configuración de la barra de aplicaciones.
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent, // Fondo transparente para la barra.
    elevation: 0, // Sin sombra o elevación.
    iconTheme: IconThemeData(color: Colors.black), // Color de los íconos en la barra.
    titleTextStyle: TextStyle(
      color: Colors.black, // Color del texto del título.
      fontSize: 20, // Tamaño de fuente del título.
    ),
  ),

  /// Esquema de colores del tema.
  colorScheme: ColorScheme.light(
    surface: Colors.grey[300]!, // Color para superficies secundarias (fondo de tarjetas, etc.).
    primary: Colors.grey[200]!, // Color principal del tema.
    secondary: Colors.grey[300]!, // Color secundario para detalles.
  ),

  /// Configuración de botones de texto.
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black, // Color del texto en los botones.
    ),
  ),
);