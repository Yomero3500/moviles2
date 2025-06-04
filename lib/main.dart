import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Asegúrate de importar esto
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final user = FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Productos',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: user == null ? LoginScreen() : HomeScreen(user: user),
  ));
}
