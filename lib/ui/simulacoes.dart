import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './styles/colors.dart';
import '../models/financiamento.dart';
import '../root/file.dart';

class Simulacoes extends StatefulWidget {
  const Simulacoes({super.key});

  @override
  State<Simulacoes> createState() => _SimulacoesState();
}

class _SimulacoesState extends State<Simulacoes> {
  List<Financiamento> dados = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
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

  void salvarDados() {
    String conteudo = dados.map((a) => a.toCSV()).join('\n');
    GerenciaArquivo.salvarArquivo(conteudo);
  }

  void modalDelete(int indice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Simulação'),
          content: Text('Tem certeza que deseja excluir esta simulação?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  dados.removeAt(indice);
                });
                salvarDados();
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulações')),
      body: Center(
        child: ListView.separated(
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(dados[i].data.toString()))} - ${DateFormat('hh:mm').format(DateTime.parse(dados[i].data.toString()))}',
              ),
              subtitle: Text(
                'Valor: R\$ ${dados[i].valor.toStringAsFixed(2)}, Taxa: ${dados[i].taxa.toStringAsFixed(2)}%,\nCustos: R\$ ${dados[i].custos.toStringAsFixed(2)}, Montante: R\$ ${dados[i].montante().toStringAsFixed(2)},\n${dados[i].parcelas} parcelas de: R\$ ${dados[i].parcela().toStringAsFixed(2)}',
              ),
              trailing: GestureDetector(
                onTap: () {
                  modalDelete(i);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.p1,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete, color: AppColors.p4),
                ),
              ),
            );
          },
          separatorBuilder: (_, _) => Divider(),
          itemCount: dados.length,
        ),
      ),
    );
  }
}
