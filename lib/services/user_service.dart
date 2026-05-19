import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String usuariosKey = 'usuarios';

  Future<void> cadastrarUsuario(String nome, String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();

    final listaAtual = prefs.getStringList(usuariosKey) ?? [];

    final novoUsuario = {
      'nome': nome,
      'email': email,
      'senha': senha,
    };

    listaAtual.add(jsonEncode(novoUsuario));

    await prefs.setStringList(usuariosKey, listaAtual);
  }

  Future<bool> validarLogin(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();

    final listaAtual = prefs.getStringList(usuariosKey) ?? [];

    for (final usuarioJson in listaAtual) {
      final usuario = jsonDecode(usuarioJson);

      if (usuario['email'] == email && usuario['senha'] == senha) {
        return true;
      }
    }

    return false;
  }
}