import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_wall_app/components/drawer.dart';
import 'package:the_wall_app/components/text_field.dart';
import 'package:the_wall_app/components/wall_post.dart';
import 'package:the_wall_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!; // Usuario actual autenticado
  final textController = TextEditingController(); // Controlador de texto para el post

  // Método para cerrar sesión
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Método para publicar un mensaje en Firestore
  void postMessage() {
    if (textController.text.isNotEmpty) {
      // Publicar el mensaje en la colección "User Posts" de Firestore
      FirebaseFirestore.instance.collection("User Posts").add({
        'Message': textController.text,
        'UserEmail': currentUser.email,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      textController.clear(); // Limpiar el campo de texto después de publicar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Color de fondo de la pantalla
      appBar: AppBar(
        title: const Text("The Wall"), // Título de la app
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // Ícono de menú
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abrir el Drawer al hacer clic en el ícono
            },
          ),
        ),
        actions: [
          // Botón de cerrar sesión
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(
        onTapLogout: signOut, // Cerrar sesión desde el Drawer
        onTapProfile: () {
          // Navegar a la página de perfil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
      body: Center(
        child: Column(
          children: [
            // Lista de publicaciones
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts") // Recolecta los posts
                    .orderBy("TimeStamp", descending: false) // Ordenar por fecha
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs; // Obtiene los posts
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index]; // Cada post
                        return WallPost(
                          message: post["Message"],
                          user: post["UserEmail"],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []), // Obtiene los likes
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(), // Indicador de carga
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // Campo de texto para escribir un mensaje
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Write something on the wall...",
                      obscureText: false, // Campo de texto sin ocultar caracteres
                    ),
                  ),
                  // Botón para publicar el mensaje
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            // Mostrar el email del usuario logueado
            Text(
              "Logged in as: " + currentUser.email!,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}