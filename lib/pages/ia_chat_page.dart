import 'package:flutter/material.dart';
import '../services/ia_service.dart';

class IaChatPage extends StatefulWidget {
  @override
  _IaChatPageState createState() => _IaChatPageState();
}

class _IaChatPageState extends State<IaChatPage> {
  final perguntaController = TextEditingController();
  final iaService = IaService();

  String resposta = '';
  bool carregando = false;

  void enviarPergunta() async {
    if (perguntaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite uma pergunta')),
      );
      return;
    }

    setState(() {
      carregando = true;
      resposta = '';
    });

    final resultado = await iaService.perguntar(perguntaController.text);

    setState(() {
      resposta = resultado;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IA Chat PetSaúde'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: perguntaController,
              decoration: InputDecoration(
                labelText: 'Pergunte algo sobre o pet',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: carregando ? null : enviarPergunta,
              child: carregando
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Perguntar para IA'),
            ),
            SizedBox(height: 20),
            if (resposta.isNotEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    resposta,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}