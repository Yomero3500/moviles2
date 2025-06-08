import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import 'register_view.dart';
import '../../products/screens/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscure = true;
  bool _loading = false;
  final AuthService authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _loading = true);
      try {
        final userCredential = await authService.signInWithEmailAndPassword(
            _email, _password);
        setState(() => _loading = false);
        if (userCredential != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeView(user: userCredential.user!)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Credenciales incorrectas')),
          );
        }
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);
    final user = await authService.signInWithGoogle();
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeView(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.jpg',
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) => value == null || value.isEmpty
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese contraseña'
                          : null,
                      onSaved: (value) => _password = value ?? '',
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child: Text('Ingresar')),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RegisterView()),
                              );
                            },
                      child: Text('Crear una cuenta'),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      label: Text("Iniciar sesión con Google"),
                      onPressed: _loading ? null : _loginWithGoogle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
