import '../models/app_category.dart';
import '../models/video_item.dart';
import 'api_client.dart';

class ContentService {
  final ApiClient _api = ApiClient();

  Future<List<AppCategory>> fetchCategories() async {
    try {
      final j = await _api.getJson('/categories');
      final list = (j['categories'] ?? j['data'] ?? []) as List;
      return list.map((e) => AppCategory.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [
        AppCategory(id: '0', nombre: 'Todos', descripcion: ''),
        AppCategory(id: '1', nombre: 'Pasarela', descripcion: ''),
        AppCategory(id: '2', nombre: 'Postura', descripcion: ''),
        AppCategory(id: '3', nombre: 'Maquillaje', descripcion: ''),
      ];
    }
  }

  Future<List<VideoItem>> fetchVideos({String? categoryId}) async {
    try {
      final j = await _api.getJson('/videos', query: {'categoryId': categoryId ?? ''});
      final list = (j['videos'] ?? j['data'] ?? []) as List;
      return list.map((e) => VideoItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Datos de ejemplo (mezcla premium/no premium)
      final sample = List.generate(8, (i) => VideoItem(
        id: '$i',
        titulo: 'Clase ${i + 1}',
        thumbnailUrl: 'https://picsum.photos/seed/v$i/600/400',
        categoriaId: (i % 3 + 1).toString(),
        premium: i % 3 != 0,
      ));
      return sample;
    }
  }

  Future<String> fetchVideoUrl(String id) async {
    try {
      final j = await _api.getJson('/videos/$id');
      return (j['url'] ?? j['videoUrl'] ?? '') as String;
    } catch (_) {
      // demo: un mp4 público para probar player
      return 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4';
    }
  }
}
