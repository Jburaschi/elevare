import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _auth = AuthService();
  User? _user;
  String? _token;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.role == 'admin';
  bool get hasPaid => _user?.estadoPago == true;

  Future<void> login(String email, String password) async {
    _user = await _auth.login(email, password);
    _token = await _auth.getToken();
    notifyListeners();
  }

  Future<void> register(String nombre, String email, String password) async {
    _user = await _auth.register(nombre, email, password);
    _token = await _auth.getToken();
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.logout();
    _user = null;
    _token = null;
    notifyListeners();
  }
}
