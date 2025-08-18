import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../config.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final u = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi cuenta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(u?.nombre ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(u?.email ?? ''),
                const SizedBox(height: 12),
                Row(children: [
                  const Text('Estado de pago: '),
                  Chip(label: Text(auth.hasPaid ? 'Pagado' : 'Pendiente'), backgroundColor: auth.hasPaid ? Colors.green.shade700 : Colors.orange.shade800),
                ]),
                const SizedBox(height: 12),
                if (!auth.hasPaid)
                  FilledButton(onPressed: () => launchUrlString('${AppConfig.baseUrl}/pay'), child: const Text('Realizar pago único')),
                const SizedBox(height: 12),
                Row(children: [
                  OutlinedButton(onPressed: () => context.go('/home'), child: const Text('Ir al contenido')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => auth.logout().then((_) => context.go('/login')), child: const Text('Cerrar sesión')),
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
