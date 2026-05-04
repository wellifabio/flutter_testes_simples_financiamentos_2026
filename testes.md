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