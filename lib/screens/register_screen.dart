import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscure = true;
  final AuthService authService = AuthService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Intentar registrar con Firebase Auth
        final user = await authService.registerWithEmail(_email, _password);
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado en Firebase: $_email')),
          );
          Navigator.pop(context);
          return;
        }
      } catch (e) {
        // Si falla Firebase, intentar registrar con backend propio
        try {
          final response = await http.post(
            Uri.parse('http://192.168.1.235:3000/Clients/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': _email, 'password': _password}),
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Usuario registrado: $_email')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al registrar usuario')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Usuario')),
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
                  keyboardType: TextInputType.emailAddress,
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
                ElevatedButton(onPressed: _register, child: Text('Registrar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
