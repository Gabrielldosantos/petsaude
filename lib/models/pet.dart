class Pet {
  int? id;
  String nome;
  String tipo;

  Pet({this.id, required this.nome, required this.tipo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
    );
  }
}