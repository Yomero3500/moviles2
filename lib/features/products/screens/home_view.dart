import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/screens/login_view.dart';
import 'product_list_view.dart';

class HomeView extends StatelessWidget {
  final User user;
  final AuthService authService = AuthService();
  HomeView({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${user.displayName ?? user.email}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginView()),
                (route) => false, // Esto remueve todas las rutas anteriores
              );
            },
          ),
        ],
      ),
      body: ProductListView(),
    );
  }
}
