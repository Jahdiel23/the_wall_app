import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_wall_app/auth/login_or_register.dart';
import 'package:the_wall_app/pages/home_page.dart';

/// A widget that handles the authentication flow.
///
/// Depending on whether the user is logged in or not, it either redirects
/// to the home page or shows the login/register screen.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The StreamBuilder listens to changes in the authentication state.
      body: StreamBuilder<User?>(
        // Stream from FirebaseAuth that provides the user's authentication state.
        stream: FirebaseAuth.instance.authStateChanges(),
        
        builder: (context, snapshot) {
          // If user data is present, the user is logged in.
          if (snapshot.hasData) {
            // Redirect to the home page.
            return const HomePage();
          } else {
            // If user is not logged in, show the login/register screen.
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}