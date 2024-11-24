import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/components/comment_button.dart';
import 'package:the_wall_app/components/comments.dart';
import 'package:the_wall_app/components/like_button.dart';
import 'package:the_wall_app/helpers/helpers_methodos.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // Usuario actual
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // Controlador para texto de comentarios
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // Alternar "Me gusta"
  void toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });

    try {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

      if (isLiked) {
        // Agregar usuario a la lista de likes
        await postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email]),
        });
      } else {
        // Eliminar usuario de la lista de likes
        await postRef.update({
          'Likes': FieldValue.arrayRemove([currentUser.email]),
        });
      }
    } catch (e) {
      // Manejo de errores
      setState(() {
        isLiked = !isLiked; // Revertir el cambio
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating likes: $e')),
      );
    }
  }

  // Agregar un comentario
  void addComment(String commentText) async {
    if (commentText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("User Posts")
          .doc(widget.postId)
          .collection("Comments")
          .add({
        "CommentText": commentText,
        "CommentedBy": currentUser.email,
        "CommentTime": Timestamp.now(),
      });

      _commentTextController.clear(); // Limpiar campo de texto
      Navigator.pop(context); // Cerrar diálogo
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    }
  }

  // Mostrar diálogo para comentarios
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          // Botón de cancelar
          TextButton(
            onPressed: () {
              _commentTextController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          // Botón de publicar
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mensaje del post
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(height: 5),
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Botones de "Me gusta" y comentarios
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              CommentButton(onTap: showCommentDialog),
            ],
          ),
          const SizedBox(height: 20),
          // Lista de comentarios
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final comments = snapshot.data!.docs;

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc ){
                  final comentData = doc.data() as Map<String, dynamic>;
                
                  return Comment(
                    text: comentData["Comment text"],
                    user: comentData["CommentedBy"],
                    time: formatData(comentData["Commented time"])
                  );
                  }).toList(),
                        
              );
            },
          ),
        ],
      ),
    );
  }
}