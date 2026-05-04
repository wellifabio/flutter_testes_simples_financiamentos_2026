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

  String toCSV() {
    return '$data,$valor,$taxa,$parcelas,$custos';
  }
}
