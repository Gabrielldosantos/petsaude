import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/pet.dart';
import '../models/consulta.dart';

class PetService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'pets.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            tipo TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE consultas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nomePet TEXT,
            data TEXT,
            descricao TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertPet(Pet pet) async {
    final db = await database;
    await db.insert('pets', pet.toMap());
  }

  Future<List<Pet>> getPets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pets');
    return maps.map((e) => Pet.fromMap(e)).toList();
  }

  Future<void> insertConsulta(Consulta consulta) async {
    final db = await database;
    await db.insert('consultas', consulta.toMap());
  }

  Future<List<Consulta>> getConsultas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('consultas');
    return maps.map((e) => Consulta.fromMap(e)).toList();
  }
}