import 'package:cloud_firestore/cloud_firestore.dart'; 
// Importa Cloud Firestore para almacenar datos de usuario.

import 'package:firebase_auth/firebase_auth.dart'; 
// Importa Firebase Authentication para gestionar el registro de usuarios.

import 'package:flutter/material.dart'; 
// Importa Flutter para construir la interfaz de usuario.

import 'package:the_wall_app/components/button.dart';
// Importa un componente personalizado para los botones (MyButton).

import 'package:the_wall_app/components/text_field.dart'; 
// Importa un componente personalizado para los campos de texto (MyTextField).

class RegisterPage extends StatefulWidget { 
  // Página de registro, es un widget con estado.

  final Function()? onTap; 
  // Callback opcional para manejar el cambio a la página de inicio de sesión.

  const RegisterPage({super.key, required this.onTap}); 
  // Constructor que acepta una clave única y la función `onTap`.

  @override
  State<RegisterPage> createState() => _RegisterPageState(); 
  // Crea el estado asociado a esta página.
}

class _RegisterPageState extends State<RegisterPage> { 
  // Clase que gestiona el estado de la página de registro.

  // Controladores para los campos de texto.
  final emailTextController = TextEditingController(); 
  final passwordTextController = TextEditingController(); 
  final confirmPasswordTextController = TextEditingController(); 

  // Muestra un mensaje de error en la interfaz.
  void displayMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)), 
      // Muestra un `SnackBar` con el mensaje proporcionado.
    );
  }

  // Función para registrar al usuario.
  void signUp() async {
    // Muestra un indicador de carga mientras se realiza el registro.
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(), 
        // Indicador de progreso circular.
      ),
    );

    // Verifica que las contraseñas coincidan.
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context); // Cierra el diálogo de carga.
      displayMessage("Passwords don't match"); 
      // Muestra un mensaje de error.
      return;
    }

    try {
      // Intenta crear un usuario en Firebase Authentication.
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // Después de crear el usuario, crea un documento en Firestore en la colección "Users".
      FirebaseFirestore.instance
          .collection("Users") // Nombre de la colección.
          .doc(userCredential.user!.email) // El documento es el email del usuario.
          .set({
        'username': emailTextController.text.split('@')[0], 
        // Nombre inicial del usuario basado en la parte anterior al '@' del email.

        'bio': 'Empty bio..' 
        // Biografía inicial vacía.
        // Aquí puedes añadir más campos según sea necesario.
      });

      // Cierra el indicador de carga si el widget sigue activo.
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) { 
      // Captura errores específicos de Firebase Authentication.

      Navigator.pop(context); 
      // Cierra el indicador de carga.

      displayMessage(e.code); 
      // Muestra el código de error en un mensaje.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario para la página de registro.

    return Scaffold(
      backgroundColor: Colors.grey[300], 
      // Establece un color de fondo gris claro.

      body: SafeArea(
        // Asegura que el contenido esté dentro de los límites seguros del dispositivo.
        child: SingleChildScrollView(
          // Permite desplazarse si el contenido excede la pantalla.
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0), 
              // Agrega un padding horizontal de 25 píxeles.

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                // Centra los elementos verticalmente.

                children: [
                  const SizedBox(height: 50), 
                  // Espaciado inicial.

                  // Logo.
                  const Icon(
                    Icons.lock, 
                    size: 100, 
                    // Icono de candado grande.
                  ),

                  const SizedBox(height: 50), 
                  // Espaciado entre el logo y el mensaje.

                  // Mensaje de bienvenida.
                  Text(
                    "Let's create an account for you!", 
                    // Texto de bienvenida.

                    style: TextStyle(
                      color: Colors.grey[700], 
                      // Texto en gris oscuro.
                      fontSize: 16, 
                      // Tamaño de fuente.
                    ),
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

                  const SizedBox(height: 10), 
                  // Espaciado entre campos.

                  // Campo de texto para la contraseña.
                  MyTextField(
                    controller: passwordTextController, 
                    hintText: 'Password', 
                    obscureText: true, 
                    // El texto está oculto (para contraseñas).
                  ),

                  const SizedBox(height: 10), 
                  // Espaciado entre campos.

                  // Campo de texto para confirmar la contraseña.
                  MyTextField(
                    controller: confirmPasswordTextController, 
                    hintText: 'Confirm Password', 
                    obscureText: true, 
                  ),

                  const SizedBox(height: 25), 
                  // Espaciado entre los campos y el botón.

                  // Botón de registro.
                  MyButton(onTap: signUp, text: 'Sign Up'), 
                  // Llama a la función `signUp` cuando se presiona.

                  const SizedBox(height: 25), 
                  // Espaciado entre el botón y el enlace.

                  // Enlace para volver a la página de inicio de sesión.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    // Centra los elementos horizontalmente.

                    children: [
                      Text(
                        "Already have an account?", 
                        // Texto de invitación.

                        style: TextStyle(
                          color: Colors.grey[700], 
                          // Texto en gris oscuro.
                        ),
                      ),

                      const SizedBox(width: 4), 
                      // Espaciado entre el texto y el enlace.

                      GestureDetector(
                        onTap: widget.onTap, 
                        // Llama a la función `onTap` pasada como argumento.

                        child: const Text(
                          "Login now", 
                          // Texto del enlace.

                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            // Texto en negrita.

                            color: Colors.blue, 
                            // Texto en color azul.
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50), 
                  // Espaciado final.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}