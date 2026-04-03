import 'package:flutter/material.dart';
import 'package:petsaude/pages/cadastro_pet_page.dart';
import 'package:petsaude/services/pet_service.dart';
import 'package:petsaude/models/pet.dart';

void main() {
  runApp(MyApp());
}

// ================= APP =================
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetSaúde',
      home: LoginPage(),
    );
  }
}

// ================= LOGIN =================
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String erro = '';

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  void validarLogin() {
    setState(() {
      erro = '';
    });

    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      setState(() {
        erro = 'Preencha todos os campos';
      });
    } else if (!emailController.text.contains('@')) {
      setState(() {
        erro = 'Email inválido';
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade100,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Container(
              width: 350,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pets, size: 60, color: Colors.blue),

                  SizedBox(height: 10),

                  Text(
                    'PetSaúde',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  if (erro.isNotEmpty)
                    Text(
                      erro,
                      style: TextStyle(color: Colors.red),
                    ),

                  SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: validarLogin,
                      child: Text('Entrar'),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CadastroPage()),
                      );
                    },
                    child: Text('Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= HOME =================
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final petService = PetService();
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    carregarPets();
  }

  Future<void> carregarPets() async {
    final lista = await petService.getPets();

    print("PETS CARREGADOS: ${lista.length}");

    setState(() {
      pets = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Pets")),
      body: Column(
        children: [
          SizedBox(height: 10),

          ElevatedButton(
            child: Text("Cadastrar Pet"),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CadastroPetPage(),
                ),
              );

              if (result == true) {
                await carregarPets(); // 🔥 atualiza só quando voltar
              }
            },
          ),

          SizedBox(height: 10),

          Expanded(
            child: pets.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum pet cadastrado 😢",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Icon(Icons.pets, color: Colors.blue),
                          title: Text(
                            pet.nome,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(pet.tipo),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
// ================= CADASTRO USUÁRIO =================
class CadastroPage extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void cadastrar(BuildContext context) {
    if (nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => cadastrar(context),
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}