import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/components/button.dart';
import 'package:the_wall_app/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Sign in function
  void signIn() async {
    // Show loading circle
    showDialog(
      context: context, 
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Validate input fields
    if (emailTextController.text.isEmpty || passwordTextController.text.isEmpty) {
      Navigator.pop(context); // Pop the loading dialog
      displayMessage("Please fill in both email and password.");
      return;
    }

    // Try sign in
    try { 
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, 
        password: passwordTextController.text,
      );

      // Pop loading circle if the widget is still mounted
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop loading circle if the widget is still mounted
      if (mounted) Navigator.pop(context);

      // Display error message
      displayMessage(e.message ?? "An error occurred");
    }
  }

  // Display a dialog message
  void displayMessage(String message) {
    if (mounted) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const Icon(Icons.lock, size: 100),
                
                const SizedBox(height: 50),
                
                // Welcome back message
                Text(
                  "Welcome back, long time we don't see you",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                
                const SizedBox(height: 25),
                
                // Email text field
                MyTextField(
                  controller: emailTextController, 
                  hintText: 'Email', 
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                
                // Password text field
                MyTextField(
                  controller: passwordTextController, 
                  hintText: 'Password', 
                  obscureText: true,
                ),
                
                const SizedBox(height: 10),
                
                // Sign in button
                MyButton(onTap: signIn, text: 'Sign In'),
                const SizedBox(height: 25),
                
                // Go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?", 
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now!", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
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
