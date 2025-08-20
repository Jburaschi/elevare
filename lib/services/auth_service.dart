import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  Future<AppUser> login(String email, String pass) async {
    try {
      final j = await _api.postJson('/auth/login', {'email': email, 'password': pass});
      return AppUser.fromJson(j['user'] ?? j);
    } catch (_) {
      // Fallback demo user
      return AppUser(id: '1', email: email, estadoPago: false);
    }
  }

  Future<AppUser> register(String email, String pass) async {
    try {
      final j = await _api.postJson('/auth/register', {'email': email, 'password': pass});
      return AppUser.fromJson(j['user'] ?? j);
    } catch (_) {
      return AppUser(id: '2', email: email, estadoPago: false);
    }
  }
}
