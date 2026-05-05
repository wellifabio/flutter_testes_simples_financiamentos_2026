import 'dart:math';

class Financiamento {
  DateTime data;
  double valor;
  double taxa;
  int parcelas;
  double custos;

  Financiamento({
    required this.data,
    required this.valor,
    required this.taxa,
    required this.parcelas,
    required this.custos,
  });

  double montante() {
    return valor * pow(1 + taxa / 100, parcelas) + custos;
  }

  double parcela() {
    return parcelas != 0 ? montante() / parcelas : 0;
  }

  String toCSV() {
    return '$data,$valor,$taxa,$parcelas,$custos';
  }
}
