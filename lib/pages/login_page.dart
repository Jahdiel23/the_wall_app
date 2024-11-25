import 'package:firebase_auth/firebase_auth.dart'; 
// Importa Firebase Authentication para gestionar el inicio de sesión de usuarios.

import 'package:flutter/material.dart'; 
// Importa Flutter para construir la interfaz de usuario.

import 'package:the_wall_app/components/button.dart';
// Importa un componente personalizado para los botones (MyButton).

import 'package:the_wall_app/components/text_field.dart'; 
// Importa un componente personalizado para los campos de texto (MyTextField).

class LoginPage extends StatefulWidget { 
  // Clase de la página de inicio de sesión, es un widget con estado.

  final Function()? onTap; 
  // Callback opcional para manejar el cambio a la página de registro.

  const LoginPage({super.key, required this.onTap}); 
  // Constructor que acepta una clave única y la función `onTap` como argumentos.

  @override
  State<LoginPage> createState() => _LoginPageState(); 
  // Crea el estado asociado a esta página, gestionado por `_LoginPageState`.
}

class _LoginPageState extends State<LoginPage> { 
  // Clase que gestiona el estado de la página de inicio de sesión.

  // Controladores para los campos de texto de email y contraseña.
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Función para iniciar sesión.
  void signIn() async {
    // Muestra un indicador de carga mientras se realiza el inicio de sesión.
    showDialog(
      context: context, 
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Valida que los campos no estén vacíos.
    if (emailTextController.text.isEmpty || passwordTextController.text.isEmpty) {
      Navigator.pop(context); // Cierra el diálogo de carga.
      displayMessage("Please fill in both email and password."); 
      // Muestra un mensaje de error.
      return;
    }

    // Intenta iniciar sesión con Firebase Authentication.
    try { 
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, 
        password: passwordTextController.text,
      );

      // Cierra el indicador de carga si el widget sigue activo.
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) { 
      // Captura errores específicos de Firebase Authentication.

      if (mounted) Navigator.pop(context); 
      // Cierra el indicador de carga si ocurre un error.

      displayMessage(e.message ?? "An error occurred"); 
      // Muestra un mensaje con el error devuelto por Firebase.
    }
  }

  // Función para mostrar un diálogo con un mensaje.
  void displayMessage(String message) {
    if (mounted) { 
      // Verifica que el widget esté activo antes de mostrar el diálogo.
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(message), 
          // Muestra el mensaje pasado como argumento.
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz visual de la página de inicio de sesión.

    return Scaffold(
      backgroundColor: Colors.grey[300], 
      // Establece un fondo gris claro.

      body: SafeArea(
        // Asegura que el contenido esté dentro de los límites seguros del dispositivo.
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0), 
            // Define un padding horizontal de 25 píxeles.

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              // Centra los elementos verticalmente.

              children: [
                // Logo
                const Icon(Icons.lock, size: 100), 
                // Muestra un ícono de candado grande como logo.

                const SizedBox(height: 50), 
                // Espaciado entre el logo y el mensaje de bienvenida.

                // Mensaje de bienvenida.
                Text(
                  "Welcome back, long time we don't see you", 
                  style: TextStyle(color: Colors.grey[700]), 
                  // Texto en gris oscuro.
                ),

                const SizedBox(height: 25), 
                // Espaciado entre el mensaje y el primer campo de texto.

                // Campo de texto para el email.
                MyTextField(
                  controller: emailTextController, 
                  // Controlador del texto.

                  hintText: 'Email', 
                  // Texto de sugerencia en el campo.

                  obscureText: false, 
                  // El texto no está oculto.
                ),

                const SizedBox(height: 25), 
                // Espaciado entre los campos de texto.

                // Campo de texto para la contraseña.
                MyTextField(
                  controller: passwordTextController, 
                  hintText: 'Password', 
                  obscureText: true, 
                  // El texto está oculto (para contraseñas).
                ),

                const SizedBox(height: 10), 
                // Espaciado entre el campo de contraseña y el botón.

                // Botón de inicio de sesión.
                MyButton(onTap: signIn, text: 'Sign In'), 
                // Llama a la función `signIn` cuando se presiona.

                const SizedBox(height: 25), 
                // Espaciado entre el botón y la opción de registro.

                // Opción para ir a la página de registro.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  // Centra los elementos horizontalmente.

                  children: [
                    Text(
                      "Not a member?", 
                      style: TextStyle(color: Colors.grey[700]), 
                      // Texto en gris oscuro.
                    ),

                    const SizedBox(width: 4), 
                    // Espaciado entre el texto y el enlace.

                    GestureDetector(
                      onTap: widget.onTap, 
                      // Llama a la función `onTap` pasada como argumento al tocar el texto.

                      child: const Text(
                        "Register now!", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue), 
                        // Texto en negrita y color azul.
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}