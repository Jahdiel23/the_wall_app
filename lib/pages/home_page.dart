import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_wall_app/components/drawer.dart';
import 'package:the_wall_app/components/text_field.dart';
import 'package:the_wall_app/components/wall_post.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/pages/profile_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!; // Usuario actual
  final textController = TextEditingController(); // Controlador de texto
  //sign user out
  void signOut() {
    FirebaseAuth.instance.signOut(); // Cerrar sesión
  }
  void postMessage() {
    // Publicar solo si hay texto
    if (textController.text.isNotEmpty) {
        FirebaseFirestore.instance.collection("User Posts").add({
        'Message': textController.text,
        'UserEmail': currentUser.email,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      textController.clear();
    }
    }
    //navigate to profile page
    void goToProfilePage(){
      //pop menu drawer
      Navigator.pop(context);
      // go to profile page
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("The Wall"),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signOut, // Botón de cerrar sesión
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: MyDrawer(
        onTapProfile: goToProfilePage,
        onTapLogout: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return WallPost(
                          message: post["Message"],
                          user: post["UserEmail"],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Write something on the wall...",
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            Text(
              "Logged in as: ${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
           ),
            const SizedBox(
              height: 50,
              )
          ],
        ),
      ),
    );
  }
}