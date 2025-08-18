import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient();
  static const _tokenKey = 'auth_token';

  Future<User> login(String email, String password) async {
    final res = await _api.post('/auth/login', {'email': email, 'password': password});
    final token = res['token'] as String? ?? '';
    final userMap = res['user'] as Map<String, dynamic>? ?? {};
    final user = User.fromJson(userMap);
    final prefs = await SharedPreferences.getInstance();
    if (token.isNotEmpty) await prefs.setString(_tokenKey, token);
    return user;
  }

  Future<User> register(String nombre, String email, String password) async {
    final res = await _api.post('/auth/register', {'nombre': nombre, 'email': email, 'password': password});
    final token = res['token'] as String? ?? '';
    final userMap = res['user'] as Map<String, dynamic>? ?? {};
    final user = User.fromJson(userMap);
    final prefs = await SharedPreferences.getInstance();
    if (token.isNotEmpty) await prefs.setString(_tokenKey, token);
    return user;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
