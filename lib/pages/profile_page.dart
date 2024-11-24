import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables para almacenar los datos
  String? username;
  String? email;
  String? bio;

  // Controladores para los campos de texto
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario al iniciar la página
    loadUserData();
  }

  // Función para cargar los datos del usuario desde Firestore
  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        email = user.email;
      });

      // Obtener datos adicionales (como username y bio) desde Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      
      if (snapshot.exists) {
        setState(() {
          username = snapshot['username'] ?? 'No username set';
          bio = snapshot['bio'] ?? 'No bio available';
        });
      } else {
        // Cambié el mensaje aquí
        setState(() {
          username = 'No username set';
          bio = 'No bio available';
        });
      }
    }
  }

  // Función para actualizar el username o bio
  Future<void> updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Actualizar los datos en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': usernameController.text,
        'bio': bioController.text,
      }, SetOptions(merge: true)); // Merge para no sobrescribir los demás campos

      // Recargar los datos
      loadUserData();
    }
  }

  // Función para eliminar los datos de bio
  Future<void> deleteBio() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'bio': FieldValue.delete(),
      });

      // Recargar los datos
      loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar el email
            Text('Email: $email', style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Mostrar el username
            Text('Username: $username', style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Mostrar la bio
            Text('Bio: $bio', style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Formulario para cambiar username y bio
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Update Username',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'Update Bio',
              ),
            ),

            const SizedBox(height: 20),

            // Botón para actualizar los datos
            ElevatedButton(
              onPressed: updateUserData,
              child: const Text('Update Info'),
            ),

            const SizedBox(height: 20),

            // Botón para borrar la bio
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