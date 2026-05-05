import '../lib/ui/styles/theme.dart';
import '../lib/ui/simulacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Teste de simulação de financiamento', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Anotações',
        theme: AppTheme.appTheme,
        home: Simulacao(),
      ),
    );
    // Aguarde a renderização do widget Simulacao
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('valor')), '10000');
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byKey(Key('taxa')), '0.78');
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byKey(Key('parcelas')), '24');
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byKey(Key('custos')), '800');
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('calcular')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('salvar')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    //Aguardar mais 10 na outra tela para garantir que os dados sejam processados e exibidos corretamente
    await tester.pump(const Duration(seconds: 10));
    // Verificar se o widget com o texto "Simulações" está presente na árvore de widgets
    expect(find.text('Simulações'), findsOneWidget);
    // Verificar se os widget com o texto contendo "R$ 12849,93" e "R$ 535,41" estão listados nesta página, confirmando que o resultado do cálculo foi exibido corretamente.
    expect(find.textContaining('R\$ 12849,93'), findsOneWidget);
    expect(find.textContaining('R\$ 535,41'), findsOneWidget);
  });
}

/*
Dados calculados com Excel para validar os resultados do aplicativo:
Valor	Taxa	Parcelas	Custos	Montante	Valor Parcela
50000	0,75	36	1200	 66632,27 	 1850,90 
10000	0,78	24	800	 12849,93 	 535,41 
*/

/*
  1. O teste inicia renderizando o widget Simulacao dentro de um MaterialApp, garantindo que o tema seja aplicado corretamente.
  2. O teste aguarda a renderização completa do widget usando pumpAndSettle().
  3. O teste simula a entrada de dados nos campos de texto para valor, taxa, parcelas e custos, usando enterText() e aguardando um breve período entre cada entrada.
  4. O teste simula o clique no botão "Calcular" e depois no botão "Salvar", aguardando um breve período após cada ação para garantir que as operações sejam processadas.
  5. Finalmente, o teste verifica se o widget Simulacao está presente na árvore de widgets, confirmando que a interface foi renderizada corretamente após as interações.
*/
