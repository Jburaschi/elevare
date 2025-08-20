import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Registrate', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _email, decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => (v==null||v.isEmpty) ? 'Ingresá tu email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña'),
                      validator: (v) => (v==null||v.isEmpty) ? 'Ingresá tu contraseña' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _loading = true);
                          await context.read<AuthProvider>().register(_email.text, _pass.text);
                          if (context.mounted) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                          }
                        },
                        child: _loading ? const CircularProgressIndicator() : const Text('Crear cuenta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
