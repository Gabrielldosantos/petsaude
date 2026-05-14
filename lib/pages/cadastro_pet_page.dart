import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/pet.dart';
import '../services/pet_service.dart';

class CadastroPetPage extends StatefulWidget {
  @override
  _CadastroPetPageState createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {

  final nomeController = TextEditingController();
  final tipoController = TextEditingController();

  final service = PetService();

  File? imagemPet;

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();

    final imagem = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagem != null) {
      setState(() {
        imagemPet = File(imagem.path);
      });
    }
  }

  void salvarPet() async {

    if (nomeController.text.isEmpty ||
        tipoController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha os campos")),
      );

      return;
    }

    final pet = Pet(
      nome: nomeController.text,
      tipo: tipoController.text,
    );

    await service.insertPet(pet);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pet cadastrado com sucesso")),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Pet"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            GestureDetector(
              onTap: selecionarImagem,

              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,

                backgroundImage:
                    imagemPet != null
                        ? FileImage(imagemPet!)
                        : null,

                child:
                    imagemPet == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                          )
                        : null,
              ),
            ),

            SizedBox(height: 15),

            Text(
              "Toque para selecionar foto",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 25),

            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: "Nome do Pet",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: tipoController,
              decoration: InputDecoration(
                labelText: "Espécie",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: salvarPet,
                child: Text("Cadastrar Pet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}