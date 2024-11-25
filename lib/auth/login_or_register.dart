import 'package:flutter/material.dart'; 
// Importa la biblioteca de Flutter para construir la interfaz de usuario.

import 'package:the_wall_app/pages/login_page.dart';
// Importa la página de inicio de sesión (LoginPage) que se mostrará cuando el usuario quiera iniciar sesión.

import 'package:the_wall_app/pages/register_page.dart'; 
// Importa la página de registro (RegisterPage) que se mostrará cuando el usuario quiera registrarse.

class LoginOrRegister extends StatefulWidget { 
  // Define un widget con estado que alternará entre las páginas de inicio de sesión y registro.

  const LoginOrRegister({super.key}); 
  // Constructor de la clase LoginOrRegister, que acepta una clave única para identificar este widget.

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState(); 
  // Crea el estado asociado a este widget, gestionado por la clase _LoginOrRegisterState.
}

class _LoginOrRegisterState extends State<LoginOrRegister> { 
  // Clase que define el estado para LoginOrRegister. Maneja qué página mostrar.

  // Inicialmente, se mostrará la página de inicio de sesión.
  bool showLoginPage = true;

  // Alterna entre las páginas de inicio de sesión y registro.
  void tooglePages() {
    setState(() { 
      // Actualiza el estado del widget para reflejar el cambio.
      showLoginPage = !showLoginPage; 
      // Si estaba en la página de inicio de sesión, cambia a registro y viceversa.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz visual según el valor de `showLoginPage`.

    if (showLoginPage) { 
      // Si `showLoginPage` es verdadero, muestra la página de inicio de sesión.
      return LoginPage(onTap: tooglePages);  
      // Pasa la función `tooglePages` como argumento al `onTap` de LoginPage.
    } else { 
      // Si `showLoginPage` es falso, muestra la página de registro.
      return RegisterPage(onTap: tooglePages); 
      // Pasa la función `tooglePages` como argumento al `onTap` de RegisterPage.
    }
  }
}