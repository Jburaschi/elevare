import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();
  AppUser? _user;

  AppUser? get user => _user;
  bool get loggedIn => _user != null;
  bool get paid => _user?.estadoPago == true;

  Future<void> login(String email, String pass) async {
    _user = await _service.login(email, pass);
    notifyListeners();
  }

  Future<void> register(String email, String pass) async {
    _user = await _service.register(email, pass);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void markPaid() {
    if (_user != null) {
      _user = AppUser(id: _user!.id, email: _user!.email, estadoPago: true);
      notifyListeners();
    }
  }
}
