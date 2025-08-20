import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/video_card.dart';
import '../widgets/category_chip_bar.dart';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ContentProvider>().loadInitial());
  }

  @override
  Widget build(BuildContext context) {
    final content = context.watch<ContentProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elevare'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            icon: const Icon(Icons.lock_open),
            label: const Text('Ingresar'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Formate como modelo profesional', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('Mirá una vista previa. Para ver el contenido completo iniciá sesión y realizá el pago único.'),
                  const SizedBox(height: 16),
                  CategoryChipBar(
                    categories: content.categories, selectedId: content.selectedCategoryId, onSelected: content.selectCategory),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: () {
                          final w = MediaQuery.of(context).size.width;
                          if (w >= 1200) return 4;
                          if (w >= 900) return 3;
                          if (w >= 600) return 2;
                          return 1;
                        }(),
                        childAspectRatio: 16 / 9,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: content.videos.length,
                      itemBuilder: (_, i) {
                        final v = content.videos[i];
                        final locked = true; // en landing siempre bloqueado
                        return VideoCard(
                          item: v,
                          locked: locked,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: auth.loggedIn ? null : Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          icon: const Icon(Icons.shopping_bag),
          label: const Text('Acceso completo con pago único'),
        ),
      ),
    );
  }
}
