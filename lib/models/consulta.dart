class Consulta {
  int? id;
  String nomePet;
  String data;
  String descricao;

  Consulta({
    this.id,
    required this.nomePet,
    required this.data,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomePet': nomePet,
      'data': data,
      'descricao': descricao,
    };
  }

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'],
      nomePet: map['nomePet'],
      data: map['data'],
      descricao: map['descricao'],
    );
  }
}