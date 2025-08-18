import 'package:flutter/material.dart';
import '../models/video_item.dart';
import '../services/admin_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _service = AdminService();
  List<VideoItem> items = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      items = await _service.listAll();
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _openEditor({VideoItem? item}) async {
    final titulo = TextEditingController(text: item?.titulo ?? '');
    final descripcion = TextEditingController(text: item?.descripcion ?? '');
    final categoriaId = TextEditingController(text: item?.categoriaId.toString() ?? '0');
    final thumb = TextEditingController(text: item?.thumbnailUrl ?? '');
    bool premium = item?.premium ?? true;

    final res = await showDialog<bool>(context: context, builder: (ctx) {
      return StatefulBuilder(builder: (ctx, setS) => AlertDialog(
        title: Text(item == null ? 'Nuevo video' : 'Editar video'),
        content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titulo, decoration: const InputDecoration(labelText: 'Título')),
          const SizedBox(height: 8),
          TextField(controller: descripcion, decoration: const InputDecoration(labelText: 'Descripción')),
          const SizedBox(height: 8),
          TextField(controller: categoriaId, decoration: const InputDecoration(labelText: 'Categoría ID')),
          const SizedBox(height: 8),
          TextField(controller: thumb, decoration: const InputDecoration(labelText: 'Thumbnail URL')),
          const SizedBox(height: 8),
          SwitchListTile(value: premium, onChanged: (v) => setS(() => premium = v), title: const Text('Premium (requiere pago)')),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Guardar')),
        ],
      ));
    });

    if (res == true) {
      final payload = {
        'titulo': titulo.text.trim(),
        'descripcion': descripcion.text.trim(),
        'categoriaId': int.tryParse(categoriaId.text.trim()) ?? 0,
        'premium': premium,
        'thumbnailUrl': thumb.text.trim().isEmpty ? null : thumb.text.trim(),
      };
      if (item == null) {
        await _service.create(payload);
      } else {
        await _service.update(item.id, payload);
      }
      await _refresh();
    }
  }

  Future<void> _delete(VideoItem v) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text('Eliminar video'),
        content: Text('¿Eliminar "${v.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      );
    });
    if (ok == true) {
      await _service.remove(v.id);
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador'), actions: [
        IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        IconButton(onPressed: () => _openEditor(), icon: const Icon(Icons.add)),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Builder(
          builder: (_) {
            if (loading) return const Center(child: CircularProgressIndicator());
            if (error != null) return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
            if (items.isEmpty) return const Center(child: Text('Sin videos aún'));
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final v = items[i];
                return ListTile(
                  title: Text(v.titulo),
                  subtitle: Text(v.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                  leading: v.thumbnailUrl != null ? Image.network(v.thumbnailUrl!, width: 72, height: 40, fit: BoxFit.cover) : const Icon(Icons.ondemand_video),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => _openEditor(item: v), icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () => _delete(v), icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
