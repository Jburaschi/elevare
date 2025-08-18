import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../widgets/video_card.dart';
import '../widgets/category_chip.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = context.watch<ContentProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset('assets/logo.svg', width: 180, height: 36),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () => context.go('/register'),
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Aprendé modelaje con cursos en video',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Acceso de por vida con un único pago. Mirá una vista previa de nuestras clases.',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  CategoryChipBar(
                    categories: content.categories,
                    selectedId: content.selectedCategoryId,
                    onSelected: (id) => content.filterByCategory(id),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 1200 ? 4 : constraints.maxWidth > 800 ? 3 : 2;
                    final vids = content.videos;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 16 / 10,
                      ),
                      itemCount: vids.length,
                      itemBuilder: (context, i) {
                        return VideoCard(
                          item: vids[i],
                          locked: true,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (kIsWeb)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Center(
                    child: Wrap(spacing: 12, children: [
                  FilledButton(onPressed: () => context.go('/register'), child: const Text('Acceso completo (pago único)')),
                  OutlinedButton(onPressed: () => context.go('/login'), child: const Text('Ya tengo cuenta')),
                ])),
              ),
          ],
        ),
      ),
    );
  }
}
