import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/auth/delete_button.dart';
import 'package:the_wall_app/components/comment_button.dart';
import 'package:the_wall_app/components/comments.dart';
import 'package:the_wall_app/components/like_button.dart';
import 'package:the_wall_app/helpers/helpers_methodos.dart';

class WallPost extends StatefulWidget {
  // Este widget representa una publicación en el muro.

  final String message; // Mensaje de la publicación.
  final String user; // Usuario que creó la publicación.
  final String postId; // ID único de la publicación.
  final List<String> likes; // Lista de correos de usuarios que han dado like.

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
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Obtiene al usuario actualmente autenticado.

  bool isLiked = false;
  // Indica si el usuario actual ha dado like a la publicación.

  final _commentTextController = TextEditingController();
  // Controlador para el campo de texto de los comentarios.

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    // Determina si el usuario ya dio like a la publicación.
  }

  @override
  void didUpdateWidget(covariant WallPost oldWidget) {
    // Actualiza el estado cuando cambian los datos del widget.
    super.didUpdateWidget(oldWidget);
    if (widget.likes != oldWidget.likes) {
      setState(() {
        isLiked = widget.likes.contains(currentUser.email);
      });
    }
  }

  void toggleLike() async {
    // Alterna el estado de like y actualiza Firestore.

    setState(() {
      isLiked = !isLiked;
    });

    try {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

      if (isLiked) {
        await postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email]),
        });
      } else {
        await postRef.update({
          'Likes': FieldValue.arrayRemove([currentUser.email]),
        });
      }
    } catch (e) {
      // Revertir el cambio si ocurre un error.
      setState(() {
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating likes: $e')));
    }
  }

  void addComment(String commentText) async {
    // Añade un nuevo comentario a la publicación.

    if (commentText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment cannot be empty')));
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

      _commentTextController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding comment: $e')));
    }
  }

  void showCommentDialog() {
    // Muestra un cuadro de diálogo para añadir un comentario.

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _commentTextController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    // Elimina la publicación y sus comentarios asociados.

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () async {
                try {
                  final commentDocs = await FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .get();

                  final deleteComments =
                      commentDocs.docs.map((doc) => doc.reference.delete()).toList();

                  await Future.wait(deleteComments);
                  await FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .delete();

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting post: $e')));
                }
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(width: 8),
                  Text(widget.likes.length.toString(),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              CommentButton(onTap: showCommentDialog),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final commentData =
                      comments[index].data() as Map<String, dynamic>;
                  final comment = Comment(
                    text: commentData['CommentText'],
                    user: commentData['CommentedBy'],
                    time: formatData(commentData['CommentTime']),
                  );

                  return comment;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}