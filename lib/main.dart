import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_wall_app/components/firebase_options.dart';
import 'package:the_wall_app/pages/home_page.dart';
import 'package:the_wall_app/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Wall App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // La página inicial es una clase que verifica si el usuario está autenticado
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Escucha el estado de autenticación del usuario
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Muestra un indicador de carga mientras espera la conexión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Si el usuario está autenticado, lleva a la HomePage
        if (snapshot.hasData) {
          return HomePage();
        } else {
          // Si el usuario no está autenticado, lleva a la LoginPage
          return LoginPage(onTap: () {  },);
        }
      },
    );
  }
}
