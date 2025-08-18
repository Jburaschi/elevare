import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_category.dart' as app_models;
import '../models/video_item.dart';
import 'api_client.dart';

class ContentService {
  final ApiClient _api = ApiClient();

  Future<List<app_models.AppCategory>> fetchCategories() async {
    final res = await _api.get('/categories');
    final list = (res['data'] as List<dynamic>?) ?? [];
    return list.map((e) => app_models.AppCategory.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<VideoItem>> fetchVideos({int? categoryId}) async {
    final params = categoryId == null ? '' : '?categoryId=$categoryId';
    final res = await _api.get('/videos$params');
    final list = (res['data'] as List<dynamic>?) ?? [];
    return list.map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<String> getVimeoUrlOrToken(int videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final res = await _api.get('/videos/$videoId', token: token);
    // backend puede devolver { token: "..."} o { url: "https://..." }
    return (res['url'] ?? res['token'])?.toString() ?? '';
  }
}
