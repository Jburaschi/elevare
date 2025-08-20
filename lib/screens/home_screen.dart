import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/video_card.dart';
import '../widgets/category_chip_bar.dart';
import 'video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text('Elevare - Cursos'),
        actions: [
          if (!auth.paid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilledButton(
                onPressed: () {
                  // Conectar a payments/create y luego verify en tu backend
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Integrá Mercado Pago aquí')));
                },
                child: const Text('Pagar acceso'),
              ),
            ),
          IconButton(onPressed: () => context.read<AuthProvider>().logout(), icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChipBar(categories: content.categories, selectedId: content.selectedCategoryId, onSelected: content.selectCategory),
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
                        final locked = !auth.paid && v.premium;
                        return VideoCard(
                          item: v,
                          locked: locked,
                          onTap: locked ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => VideoScreen(itemId: v.id, title: v.titulo))),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
