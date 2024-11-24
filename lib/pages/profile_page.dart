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

      try {
        // Obtener datos adicionales (como username y bio) desde Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            username = snapshot.get('username') ?? 'No username set';
            bio = snapshot.get('bio') ?? 'No bio available';
          });
        } else {
          // Si el documento no existe
          setState(() {
            username = 'No username set';
            bio = 'No bio available';
          });
        }
      } catch (e) {
        // Manejo de errores (por ejemplo, si no hay conexión o hay problemas con Firestore)
        setState(() {
          username = 'Error loading username';
          bio = 'Error loading bio';
        });
      }
    }
  }

  // Función para actualizar el username o bio
  Future<void> updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Actualizar los datos en Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'username': usernameController.text,
          'bio': bioController.text,
        }, SetOptions(merge: true)); // Merge para no sobrescribir los demás campos

        // Recargar los datos
        loadUserData();
      } catch (e) {
        // Manejo de errores al actualizar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data: $e')),
        );
      }
    }
  }

  // Función para eliminar los datos de bio
  Future<void> deleteBio() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'bio': FieldValue.delete(),
        });

        // Recargar los datos
        loadUserData();
      } catch (e) {
        // Manejo de errores al borrar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete bio: $e')),
        );
      }
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
            Text('Email: $email', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Mostrar el username
            Text('Username: $username', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Mostrar la bio
            Text('Bio: $bio', style: const TextStyle(fontSize: 18)),

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
