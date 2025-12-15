import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  String? _token;
  Map<String, dynamic>? _user;
  bool _loading = false;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get loading => _loading;

  Future<void> login(String login, String password) async {
    _loading = true;
    notifyListeners();

    final result = await _authService.login(login, password);

    _token = result["token"];
    _user = result["user"];

    await _storage.write(key: "token", value: _token);

    _loading = false;
    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    _token = await _storage.read(key: "token");

    if (_token != null) {
      // optional: hit /me endpoint
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: "token");
    _token = null;
    _user = null;
    notifyListeners();
  }
}
