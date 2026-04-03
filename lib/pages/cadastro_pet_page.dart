import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class CadastroPetPage extends StatefulWidget {
  @override
  _CadastroPetPageState createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final nomeController = TextEditingController();
  final tipoController = TextEditingController();

  final petService = PetService();

  void salvarPet() async {
    if (nomeController.text.isEmpty || tipoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    final pet = Pet(
      nome: nomeController.text,
      tipo: tipoController.text,
    );

    await petService.insertPet(pet);

    print("PET SALVO!!!"); // 🔥 DEBUG

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pet cadastrado com sucesso!")),
    );

    Navigator.pop(context, true); // 🔥 IMPORTANTE
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Pet")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome do Pet"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tipoController,
              decoration: InputDecoration(labelText: "Tipo"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarPet,
              child: Text("Salvar Pet"),
            ),
          ],
        ),
      ),
    );
  }
}