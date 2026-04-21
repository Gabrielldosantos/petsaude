import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../services/pet_service.dart';

class ConsultaPage extends StatefulWidget {
  @override
  _ConsultaPageState createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  final petController = TextEditingController();
  final dataController = TextEditingController();
  final descController = TextEditingController();

  final service = PetService();

  void salvar() async {
    final consulta = Consulta(
      nomePet: petController.text,
      data: dataController.text,
      descricao: descController.text,
    );

    await service.insertConsulta(consulta);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Consulta salva")),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nova Consulta")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: petController,
              decoration: InputDecoration(labelText: "Nome do Pet"),
            ),
            TextField(
              controller: dataController,
              decoration: InputDecoration(labelText: "Data"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Descrição"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: salvar, child: Text("Salvar")),
          ],
        ),
      ),
    );
  }
}