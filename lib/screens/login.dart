import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(decoration: const InputDecoration(labelText: 'Email'), controller: email),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Contraseña'), controller: pass, obscureText: true),
              const SizedBox(height: 16),
              if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                          error = null;
                        });
                        try {
                          await context.read<AuthProvider>().login(email.text.trim(), pass.text);
                          if (!mounted) return;
                          context.go('/home');
                        } catch (e) {
                          setState(() {
                            error = e.toString();
                          });
                        } finally {
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                child: Text(loading ? 'Ingresando...' : 'Ingresar'),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => context.go('/register'), child: const Text('Crear cuenta')),
            ]),
          ),
        ),
      ),
    );
  }
}
