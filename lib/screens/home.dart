import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/video_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido'),
        actions: [
          if (auth.isAdmin) TextButton(onPressed: () => context.go('/admin'), child: const Text('Admin')),
          TextButton(onPressed: () => context.go('/profile'), child: const Text('Mi cuenta')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CategoryChipBar(
              categories: content.categories,
              selectedId: content.selectedCategoryId,
              onSelected: (id) => content.filterByCategory(id),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200 ? 4 : constraints.maxWidth > 800 ? 3 : 2;
                  final vids = content.videos;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 16 / 10),
                    itemCount: vids.length,
                    itemBuilder: (context, i) {
                      final v = vids[i];
                      final locked = !auth.hasPaid && v.premium;
                      return VideoCard(
                        item: v,
                        locked: locked,
                        onTap: () => context.go('/video/${v.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
