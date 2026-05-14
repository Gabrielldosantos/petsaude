import 'dart:async';

class IaService {
  Future<String> perguntar(String pergunta) async {
    await Future.delayed(Duration(seconds: 2));

    final texto = pergunta.toLowerCase();

    if (texto.contains('ração') || texto.contains('comida')) {
      return 'Sugestão da IA: mantenha uma alimentação balanceada e consulte um veterinário para escolher a ração ideal.';
    }

    if (texto.contains('vacina') || texto.contains('vacinação')) {
      return 'Sugestão da IA: mantenha a carteira de vacinação do pet atualizada e siga o calendário indicado pelo veterinário.';
    }

    if (texto.contains('banho') || texto.contains('higiene')) {
      return 'Sugestão da IA: mantenha a higiene do pet em dia, mas evite banhos em excesso para não prejudicar a pele.';
    }

    if (texto.contains('consulta') || texto.contains('veterinário')) {
      return 'Sugestão da IA: consultas periódicas ajudam a prevenir doenças e acompanhar a saúde do animal.';
    }

    return 'Sugestão da IA: observe o comportamento do pet e, em caso de sintomas persistentes, procure um veterinário.';
  }
}