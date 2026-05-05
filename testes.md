# Preencher Formulário
Preencher formulários automaticamente é uma parte fundamental dos testes de **widget** e **testes de integração** no Flutter. Você pode simular interações reais de usuário, como digitação e cliques em botões, para garantir que o formulário funcione conforme o esperado.

## passo a passo de como automatizar o preenchimento de um formulário:
- 1 Estrutura básica do teste
    - Utilize o pacote *flutter_test* e a função **testWidgets** para criar o teste.
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seu_app/main.dart'; // Importe seu widget

void main() {
  testWidgets('Preencher formulário e submeter', (WidgetTester tester) async {
    // 1. Renderizar o widget
    await tester.pumpWidget(MaterialApp(home: MeuFormularioWidget()));

    // ... interações aqui ...
  });
}
```
- 2  Preenchendo campos de texto (enterText)
    - Para preencher TextField ou TextFormField, utilize find.byType ou find.byKey para localizar o campo e a função enterText.
```dart
// Encontre o campo pelo tipo ou chave
final emailField = find.byType(TextFormField).first;
final passwordField = find.byType(TextFormField).last;

// Digite o texto no campo
await tester.enterText(emailField, 'usuario@exemplo.com');
await tester.enterText(passwordField, 'senha123');

// Renderize novamente para atualizar a UI
await tester.pump();
```
- 3. Clicando em Botões (tap)
    - Simule o clique no botão de envio usando tap e pumpAndSettle para aguardar animações.
```dart
final button = find.byType(ElevatedButton);
await tester.tap(button);

// Aguarda todas as animações e tarefas pendentes
await tester.pumpAndSettle();
```
- 4. Verificando os Resultados (expect)
    - Após submeter, verifique se o comportamento esperado ocorreu (ex: mudança de tela, mensagem de sucesso).
```dart
// Verifica se uma mensagem de sucesso apareceu
expect(find.text('Login realizado com sucesso!'), findsOneWidget);
```
## Exemplo Completo de Teste
```dart
testWidgets('Teste de preenchimento de formulário', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: MeuFormularioWidget()));

  // Preencher campo email
  await tester.enterText(find.byKey(Key('campo_email')), 'teste@teste.com');
  
  // Preencher campo senha
  await tester.enterText(find.byKey(Key('campo_senha')), '123456');

  // Clicar no botão
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  // Validação
  expect(find.text('Bem-vindo'), findsOneWidget);
});
```
### Dicas Importantes

- findsOneWidget: Valida que o elemento está presente.
- pumpAndSettle(): Essencial para validar formulários que fecham após um clique, pois garante que o Flutter processou todas as mudanças de tela.
- Keys: Utilizar Key (Key('campo_email')) no código de produção facilita muito a localização de widgets específicos nos testes.
- Testes de Integração: Para testes que rodam em simuladores reais ou dispositivos físicos, utilize o pacote *integration_test*.

## Onde fica o arquivo de teste
Para testes de integração no emulador o arquivo de testes deve ficar no diretório chamado **integration_test** e a dependência deve ser adicionada no arquivo pubspec.yaml
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```
Para executar os testes no emulador, o mesmo precisa estar aberto, execute o comando a seguir:
```bash
flutter test integration_test/nome_do_arquivo_de_teste.dart
```

### Exemplo de teste deste aplicativo
- Arquivo: integration_test/simulacao.dart
```dart
import '../lib/ui/styles/theme.dart';
import '../lib/ui/simulacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
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
```