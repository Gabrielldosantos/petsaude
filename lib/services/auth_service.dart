import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';

class AuthService {
  Future<LoginResponse?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'password': senha,
          'expiresInMins': 60,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return LoginResponse(
          token: data['accessToken'],
          message: 'Login realizado com sucesso via API',
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}