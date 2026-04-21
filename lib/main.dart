import 'package:flutter/material.dart';
import 'package:petsaude/pages/cadastro_pet_page.dart';
import 'package:petsaude/pages/consulta_page.dart';
import 'package:petsaude/services/pet_service.dart';
import 'package:petsaude/services/auth_service.dart';
import 'package:petsaude/models/pet.dart';
import 'package:petsaude/models/consulta.dart';

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

  final AuthService authService = AuthService();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String erro = '';
  String token = '';
  bool carregando = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  void validarLogin() async {
    setState(() {
      erro = '';
      token = '';
      carregando = true;
    });

    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      setState(() {
        erro = 'Preencha todos os campos';
        carregando = false;
      });
      return;
    }

    final resultado = await authService.login(
      emailController.text,
      senhaController.text,
    );

    if (resultado != null) {
      setState(() {
        token = resultado.token;
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado.message)),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      setState(() {
        erro = 'Email ou senha inválidos';
        carregando = false;
      });
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
                  if (token.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Token JWT: $token',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                        ),
                      ),
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
                      onPressed: carregando ? null : validarLogin,
                      child: carregando
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Entrar'),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CadastroPage()),
                      );
                    },
                    child: Text('Criar conta'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Teste da API simulada:\nEmail: gabriel@gmail.com\nSenha: 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
  List<Consulta> consultas = [];

  @override
  void initState() {
    super.initState();
    carregarPets();
    carregarConsultas();
  }

  Future<void> carregarPets() async {
    final lista = await petService.getPets();
    setState(() {
      pets = lista;
    });
  }

  Future<void> carregarConsultas() async {
    final lista = await petService.getConsultas();
    setState(() {
      consultas = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Pets e Consultas")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
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
                  await carregarPets();
                }
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text("Cadastrar Consulta"),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConsultaPage(),
                  ),
                );

                if (result == true) {
                  await carregarConsultas();
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              "Pets cadastrados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
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
            Divider(),
            Text(
              "Consultas cadastradas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: consultas.isEmpty
                  ? Center(
                      child: Text(
                        "Nenhuma consulta cadastrada 🩺",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: consultas.length,
                      itemBuilder: (context, index) {
                        final consulta = consultas[index];

                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.medical_services,
                              color: Colors.green,
                            ),
                            title: Text(
                              consulta.nomePet,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Data: ${consulta.data}\nDescrição: ${consulta.descricao}",
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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