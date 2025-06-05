import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../service/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscure = true;
  final AuthService authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Intentar login con Firebase Auth
        final user = await authService.signInWithEmail(_email, _password);
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
          );
          return;
        }
      } catch (e) {
        // Si falla Firebase, intentar login con backend propio
        try {
          final response = await http.post(
            Uri.parse('http://192.168.122.1:3000/Clients/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': _email, 'password': _password}),
          );
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['message'] == 'Login successful') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(user: data['user']),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Credenciales incorrectas')),
              );
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión')));
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
        }
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    final user = await authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProductListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Ingrese email'
                              : null,
                  onSaved: (value) => _email = value ?? '',
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  obscureText: _obscure,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Ingrese contraseña'
                              : null,
                  onSaved: (value) => _password = value ?? '',
                ),
                SizedBox(height: 32),
                ElevatedButton(onPressed: _login, child: Text('Ingresar')),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    );
                  },
                  child: Text('Crear una cuenta'),
                ),
                SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text("Iniciar sesión con Google"),
                  onPressed: _loginWithGoogle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
