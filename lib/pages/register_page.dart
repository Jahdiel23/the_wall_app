import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/components/button.dart';
import 'package:the_wall_app/components/text_field.dart';
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  // Display error message
  void displayMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  // Sign user up
  void signUp() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // Ensure passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context); // Close loading dialog
      displayMessage("Passwords don't match");
      return;
    }
    try {
      // Try creating the user
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
// after creating the user, create a new document in cloud firebase called Users
      FirebaseFirestore.instance.
      collection("Users")
      .doc(userCredential.user!.email)
      .set({
        'username' : emailTextController.text.split('@')[0], //inital user name
        'bio' : 'Empty bio..' //inital empty bio
        // add any additional fields as needed
      });


//pop loading circle
     if (context.mounted) Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    //pop loading circle
    Navigator.pop(context);
    //show error to user
    displayMessage(e.code);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  // Welcome message
                  Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Email text field
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  // Password text field
                  MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // Confirm password text field
                  MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  // Sign-up button
                  MyButton(onTap: signUp, text: 'Sign Up'),
                  const SizedBox(height: 25),
                  // Redirect to login page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}