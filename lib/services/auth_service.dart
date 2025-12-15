import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  Future<Map<String, dynamic>> login(String login, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "login": login,
        "password": password,
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw data["message"] ?? "Login gagal";
    }

    return data; // { token, user }
  }
}