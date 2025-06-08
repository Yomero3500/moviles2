import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../app/config/firebase_config.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/login_view.dart';
import '../features/products/screens/home_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: Text('Error al inicializar Firebase'))),
          );
        }
        final user = snapshot.data;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Productos',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: user == null
              ? const LoginView()
              : HomeView(user: user),
        );
      },
    );
  }

  Future<dynamic> _initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseAuth.instance.currentUser;
  }
}
