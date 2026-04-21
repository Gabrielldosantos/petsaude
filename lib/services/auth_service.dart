import 'dart:async';
import '../models/login_response.dart';

class AuthService {
  Future<LoginResponse?> login(String email, String senha) async {
    await Future.delayed(Duration(seconds: 2));

    if (email == 'gabriel@gmail.com' && senha == '123456') {
      return LoginResponse(
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake.token.assinatura',
        message: 'Login realizado com sucesso',
      );
    }

    return null;
  }
}