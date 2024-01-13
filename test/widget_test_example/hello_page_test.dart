import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/widget_test_example/hello.dart';
import 'package:testing_example/widget_test_example/hello_page.dart';

void main() {
  testWidgets('hello page ...', (tester) async {
    /*
    ProviderContainerを使って、Providerをオーバーライドする。
    Hello World! -> こんにちわ世界！に上書きをする。
    */
    final container = ProviderContainer(overrides: [
      helloProvider.overrideWithValue('こんにちわ世界！'),
    ]);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HelloPage(),
        ),
      ),
    );
    // 上書きされたので、こんにちわ世界！が表示される。
    final hello = find.text('こんにちわ世界！');
    expect(hello, findsOneWidget);// １つ見つかることを期待する。
    // こんにちわ世界2!を探す。これは存在しない。
    final hello2 = find.text('こんにちわ世界2!');
    expect(hello2, findsNothing);// １つも見つからないことを期待する。
    // find.byWidgetPredicateで、Widget Treeから特定のWidgetを探す。
    final hello3 = find.byWidgetPredicate((widget) {
      // if isで型チェックをする。
      if (widget is Text) {
        // fontSizeが25であることを期待する。
        return widget.style?.fontSize == 25;
      }
      // それ以外はfalseを返す。
      return false;
    });
    // 第１引数には、fontSize25を渡す。第２引数には、探したいWidgetの数を渡す。
    expect(hello3, findsOneWidget);
  });
}

// void main() {
//   /* Widget Testをするときは、testWidgetsを使う。
//   テストにアクセスするには、非同期にする必要があるため、asyncをつける。
//   */
//   testWidgets('hello page ...', (tester) async {
//     /* pumpWidgetでWidgetをレンダリングする。Widget Treeを構築する。
//     ロジックとUIを分離しているため、Widget Treeを構築するだけで、
//     ロジックは実行されない。
//     pumpWidgetは、Future<void>なので、awaitをつける。非同期なので待つ必要がある。
//     */
//     await tester.pumpWidget(
//       // Widget Treeを正しく構築するために、MaterialAppでラップする。
//       const MaterialApp(
//         home: HelloPage(),
//       ),
//     );
//     // find.textで、Widget Treeから特定のWidgetを探す。今回は`Hello World!`を探す。
//     final hello = find.text('Hello World!');
//     // 第１引数には、探したいWidgetを渡す。第２引数には、探したいWidgetの数を渡す。
//     expect(hello, findsOneWidget);// １つ見つかることを期待する。

//     // Hello World2!を探す。
//     final hello2 = find.text('Hello World2!');
//     expect(hello2, findsNothing);// １つも見つからないことを期待する。

//     // find.byWidgetPredicateで、Widget Treeから特定のWidgetを探す。
//     final hello3 = find.byWidgetPredicate((widget) {
//       // if isで型チェックをする。
//       if (widget is Text) {
//         // fontSizeが25であることを期待する。
//         return widget.style?.fontSize == 25;
//       }
//       // それ以外はfalseを返す。
//       return false;
//     });
//     // 第１引数には、fontSize25を渡す。第２引数には、探したいWidgetの数を渡す。
//     expect(hello3, findsOneWidget);// １つ見つかることを期待する。
//   });
// }
