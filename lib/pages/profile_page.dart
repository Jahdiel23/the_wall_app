import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Página de perfil del usuario.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables para almacenar los datos del usuario
  String? username;
  String? email;
  String? bio;

  // Controladores para los campos de texto
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario cuando se inicia la página
    loadUserData();
  }

  /// Carga los datos del usuario desde Firebase Auth y Firestore.
  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        email = user.email; // Asignar email directamente desde Firebase Auth.
      });

      // Cargar datos adicionales desde Firestore.
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          username = data.containsKey('username') ? data['username'] : 'No username set'; // Verifica si el campo existe.
          bio = data.containsKey('bio') ? data['bio'] : 'No bio available'; // Verifica si el campo existe.
        });
      } else {
        // Si no hay datos en Firestore, establecer valores por defecto.
        setState(() {
          username = 'No username set';
          bio = 'No bio available';
        });
      }
    }
  }

  /// Actualiza el username y bio del usuario en Firestore.
  Future<void> updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'username': usernameController.text,
          'bio': bioController.text,
        },
        SetOptions(merge: true), // Combinar con los datos existentes en Firestore.
      );

      // Recargar los datos del usuario.
      loadUserData();
    }
  }

  /// Elimina la bio del usuario en Firestore.
  Future<void> deleteBio() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'bio': FieldValue.delete(), // Eliminar la bio.
      });

      // Recargar los datos del usuario.
      loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Título de la página.
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar el email del usuario.
            Text('Email: $email', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Mostrar el username.
            Text('Username: $username', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Mostrar la bio.
            Text('Bio: $bio', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Campo para actualizar el username.
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Update Username',
              ),
            ),

            const SizedBox(height: 10),

            // Campo para actualizar la bio.
            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'Update Bio',
              ),
            ),

            const SizedBox(height: 20),

            // Botón para actualizar la información del usuario.
            ElevatedButton(
              onPressed: updateUserData,
              child: const Text('Update Info'),
            ),

            const SizedBox(height: 20),

            // Botón para borrar la bio.
            ElevatedButton(
              onPressed: deleteBio,
              child: const Text('Delete Bio'),
            ),
          ],
        ),
      ),
    );
  }
}
