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
    backgroundColor: const Color(0xFF181A20),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      title: Row(
        children: [
          Image.asset('assets/logo.png', height: 40),
          const SizedBox(width: 16),
          const Text(
            'Elevare',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        if (!auth.paid)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Integrá Mercado Pago aquí')));
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Pagar acceso'),
            ),
          ),
        IconButton(
          onPressed: () => context.read<AuthProvider>().logout(),
          icon: const Icon(Icons.logout, color: Colors.white),
        )
      ],
    ),
    body: content.loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.zero,
            children: [
              // Sección de bienvenida
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E2B62), Color(0xFF6C63FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Formate como modelo profesional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Accedé a todos los cursos con un solo pago.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!auth.paid)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2E2B62),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 6,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Integrá Mercado Pago aquí')));
                        },
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Desbloquear todos los cursos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Barra de categorías
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CategoryChipBar(
                  categories: content.categories,
                  selectedId: content.selectedCategoryId,
                  onSelected: content.selectCategory,
                ),
              ),
              const SizedBox(height: 24),
              // Lista de videos
              ...content.videos.map((v) {
                final locked = !auth.paid && v.premium;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: GestureDetector(
                    onTap: locked
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoScreen(itemId: v.id, title: v.titulo),
                              ),
                            ),
                    child: Stack(
                      children: [
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(v.thumbnailUrl.isNotEmpty
                                  ? v.thumbnailUrl
                                  : 'https://via.placeholder.com/400x220.png?text=Video',
                            ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.black.withOpacity(0.45),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  v.titulo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: locked ? Colors.grey : const Color(0xFF6C63FF),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        elevation: 2,
                                      ),
                                      onPressed: locked
                                          ? null
                                          : () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => VideoScreen(itemId: v.id, title: v.titulo),
                                                ),
                                              ),
                                      child: Text(locked ? 'Premium' : 'Ver'),
                                    ),
                                    if (locked)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Icon(Icons.lock, color: Colors.white70),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),
            ],
          ),
  );
}
}
