import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/home_page.dart';

void main() {
  /* Widget Testをするときは、testWidgetsを使う。
  テストにアクセスするには、非同期にする必要があるため、asyncをつける。
  */
  testWidgets('初期は0で、ボタンがクリックされたら1になる', (tester) async {
    /* pumpWidgetでWidgetをレンダリングする。Widget Treeを構築する。
    ロジックとUIを分離しているため、Widget Treeを構築するだけで、
    ロジックは実行されない。
    pumpWidgetは、Future<void>なので、awaitをつける。非同期なので待つ必要がある。
    */
    await tester.pumpWidget(
      // Widget Treeを正しく構築するために、MaterialAppでラップする。
      const MaterialApp(
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
    // find.textで、Widget Treeから特定のWidgetを探す。
    final ctr = find.text('0');
    expect(ctr, findsOneWidget);

    final ctr2 = find.text('1');
    expect(ctr2, findsNothing);

    final incrementBtn = find.byType(FloatingActionButton);
    // tester.tapは、Future<void>なので、awaitをつける。非同期なので待つ必要がある。
    await tester.tap(incrementBtn);

    await tester.pump();

    final ctr3 = find.text('1');
    expect(ctr3, findsOneWidget);

    final ctr4 = find.text('0');
    expect(ctr4, findsNothing);

    expect(find.byType(AppBar), findsOneWidget);
  });
}
