import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/login_view.dart';
import 'app/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginView(),
  ));
}
