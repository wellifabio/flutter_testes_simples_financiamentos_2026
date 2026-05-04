import 'dart:math';
import 'package:flutter/material.dart';
import './styles/colors.dart';
import '../root/file.dart';
import '../models/financiamento.dart';
import 'simulacoes.dart';

class Simulacao extends StatefulWidget {
  const Simulacao({super.key});

  @override
  State<Simulacao> createState() => _SimulacaoState();
}

class _SimulacaoState extends State<Simulacao> {
  List<Financiamento> dados = [];
  Financiamento f = Financiamento(
    data: DateTime.now(),
    valor: 0,
    taxa: 0,
    parcelas: 0,
    custos: 0,
  );

  double c = 0;
  double i = 0;
  double t = 0;
  double custos = 0;
  double m = 0;
  double p = 0;

  void calcular() {
    carregarDados();
    setState(() {
      m = c * pow(1 + i, t) + custos;
      p = m / t;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Resultado'),
          content: Text(
            'Valor total a ser pago: R\$ ${m.toStringAsFixed(2)}\n'
            'Valor da parcela: R\$ ${p.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                f.valor = c;
                f.taxa = i;
                f.parcelas = t.toInt();
                f.custos = custos;
                f.data = DateTime.now();
                dados.add(f);
                salvarDados();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void salvarDados() {
    String conteudo = dados.map((a) => a.toCSV()).join('\n');
    GerenciaArquivo.salvarArquivo(conteudo);
    irParaSimulacoes();
  }

  void carregarDados() async {
    List<String> linhas = (await GerenciaArquivo.lerArquivo()).split('\n');
    setState(() {
      dados = linhas
          .where((linha) => linha.trim().isNotEmpty)
          .map((linha) {
            List<String> partes = linha.split(',');
            if (partes.length >= 5) {
              return Financiamento(
                data: DateTime.parse(partes[0]),
                valor: double.parse(partes[1]),
                taxa: double.parse(partes[2]),
                parcelas: int.parse(partes[3]),
                custos: double.parse(partes[4]),
              );
            }
            return null;
          })
          .whereType<Financiamento>()
          .toList();
    });
  }

  void irParaSimulacoes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Simulacoes()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulador de Financiamento')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Valor do Financiamento:'),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.p1),
              decoration: InputDecoration(
                labelText: 'Digite o valor',
                hintText: 'Ex: 10000',
              ),
              onChanged: (value) {
                setState(() {
                  c = double.parse(value);
                });
              },
              textAlign: TextAlign.right,
            ),
            Text('Taxa de juros ao mês:'),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.p1),
              decoration: InputDecoration(
                labelText: 'Digite a taxa de juros',
                hintText: 'Ex: 0.75',
                suffixText: '%',
              ),
              onChanged: (value) {
                setState(() {
                  i = double.parse(value) / 100;
                });
              },
              textAlign: TextAlign.right,
            ),

            Text('Número de parcelas:'),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.p1),
              decoration: InputDecoration(
                labelText: 'Digite o número de parcelas',
                hintText: 'Ex: 12',
              ),
              onChanged: (value) {
                setState(() {
                  t = double.parse(value);
                });
              },
              textAlign: TextAlign.right,
            ),

            Text('Demais taxas e custos:'),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.p1),
              decoration: InputDecoration(
                labelText: 'Digite o total de taxas e custos adicionais',
                hintText: 'Ex: 500',
              ),
              onChanged: (value) {
                setState(() {
                  custos = double.parse(value);
                });
              },
              textAlign: TextAlign.right,
            ),

            ElevatedButton(onPressed: calcular, child: Text('Calcular')),
            ElevatedButton(
              onPressed: irParaSimulacoes,
              child: Text('Ver Simulações Anteriores'),
            ),
            Text(
              'Valor total a ser pago: R\$ ${m.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Valor da parcela: R\$ ${p.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
