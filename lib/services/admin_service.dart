import '../models/video_item.dart';
import 'api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  final ApiClient _api = ApiClient();

  Future<List<VideoItem>> listAll() async {
    final res = await _api.get('/videos');
    final list = (res['data'] as List<dynamic>?) ?? [];
    return list.map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<VideoItem> create(Map<String, dynamic> payload) async {
    final token = await _getToken();
    final res = await _api.post('/videos', payload, token: token);
    return VideoItem.fromJson(Map<String, dynamic>.from(res['data'] as Map));
  }

  Future<VideoItem> update(int id, Map<String, dynamic> payload) async {
    final token = await _getToken();
    final res = await _api.put('/videos/$id', payload, token: token);
    return VideoItem.fromJson(Map<String, dynamic>.from(res['data'] as Map));
  }

  Future<void> remove(int id) async {
    final token = await _getToken();
    await _api.delete('/videos/$id', token: token);
  }
}
