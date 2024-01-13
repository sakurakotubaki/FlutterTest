# RiverpodでWidget Testをしてみる

## 読んでほしい人
- Riverpodで、Widget Testをしてみたい人.
- 通常のWidget Testをしてみたい人.

## 補足情報
riverpodが必要なので、追加してください!

```bash
flutter pub add \
flutter_riverpod \
riverpod_annotation \
dev:riverpod_generator \
dev:build_runner \
dev:custom_lint \
dev:riverpod_lint
```

## 記事の内容
Widget Testとは、Flutterのテストフレームワークにおける一種のテスト方法で、特定のウィジェットが正しく動作するかを確認するためのものです。これは、ユニットテストと結合テストの中間的な位置づけとなっています。

具体的には、Widget Testでは以下のようなことを行います：

特定のウィジェットをレンダリングし、その結果を確認します。例えば、特定のテキストが表示されているか、特定の色が使用されているかなどを確認します。

ユーザーのインタラクション（タップ、スワイプなど）をシミュレートし、その結果を確認します。例えば、ボタンをタップしたときに特定の画面に遷移するか、特定の関数が呼び出されるかなどを確認します。

これにより、ウィジェットが期待通りの挙動をすることを確認することができます。また、テストは自動化されるため、コードの変更によってウィジェットの挙動が意図せず変わった場合にすぐに検出することができます。

### Widget Testを書いてみる
まずは、StatelessWidgetで、`Hello World!`のTextが存在するか調べてみましょう。
:::details HelloPage
```dart
import 'package:flutter/material.dart';

class HelloPage extends StatelessWidget {
  const HelloPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Page!'),
      ),
      body: const Center(
        child: Text('Hello World!', style: TextStyle(fontSize: 25)),
      ),
    );
  }
}
```
:::

テストコードを書いてみましょう。tester.pumpWidgetに、`await`にしているのは、`Future<void>`でデータが返ってくるからです。

:::details テストコード
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/widget_test_example/hello_page.dart';

void main() {
  /* Widget Testをするときは、testWidgetsを使う。
  テストにアクセスするには、非同期にする必要があるため、asyncをつける。
  */
  testWidgets('hello page ...', (tester) async {
    /* pumpWidgetでWidgetをレンダリングする。Widget Treeを構築する。
    ロジックとUIを分離しているため、Widget Treeを構築するだけで、
    ロジックは実行されない。
    pumpWidgetは、Future<void>なので、awaitをつける。非同期なので待つ必要がある。
    */
    await tester.pumpWidget(
      // Widget Treeを正しく構築するために、MaterialAppでラップする。
      const MaterialApp(
        home: HelloPage(),
      ),
    );
    // find.textで、Widget Treeから特定のWidgetを探す。今回は`Hello World!`を探す。
    final hello = find.text('Hello World!');
    // 第１引数には、探したいWidgetを渡す。第２引数には、探したいWidgetの数を渡す。
    expect(hello, findsOneWidget);// １つ見つかることを期待する。

    // Hello World2!を探す。
    final hello2 = find.text('Hello World2!');
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
    expect(hello3, findsOneWidget);// １つ見つかることを期待する。
  });
}
```
:::

### Riverpodを使う
riverpod generatorでプロバイダーを定義して、`Hello World!`の値をグローバルに渡す。

:::details プロバイダー
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'hello.g.dart';

@riverpod
String hello(HelloRef ref) {
  return 'Hello World!';
}
```
:::

プロバイダーが渡されたページ
:::details HelloPage
```dart
class HelloPage extends ConsumerWidget {
  const HelloPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hello = ref.watch(helloProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Page!'),
      ),
      body: Center(
        child: Text(hello, style: const TextStyle(fontSize: 25)),
      ),
    );
  }
}
```
:::

`overrideWithValue`でプロバイダーを上書きして、渡される値を`こんにちわ世界！`に変更します。これは依存性の注入と表現されています。

詳しく解説すると:
>依存性の注入（いぞんせいのちゅうにゅう、英: Dependency injection）とは、あるオブジェクトや関数が、依存する他のオブジェクトや関数を受け取るデザインパターンである。 英語の頭文字からDIと略される。

:::details タイトル
```dart
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
```
:::

## 最後に
今回は、Widget Testをやってみました。作成したHelloPageから指定したWidgetを探すのをやってみました。もし条件に一致しない場合はテストに失敗します。

RiverpodのWidget Testについて知りたい人は公式みてください。
https://riverpod.dev/ja/docs/essentials/testing

ウィジェットテスト
ウィジェットテストは package:flutter_test の testWidgets 関数を使って定義します。

この場合、通常の Widget テストとの主な違いは、tester.pumpWidget のルートに ProviderScope ウィジェットを追加しなければならないことです：
```dart
void main() {
  testWidgets('Some description', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YourWidgetYouWantToTest()),
    );
  });
}
```

これは、FlutterアプリでRiverpodを有効にするときに行うことと似ている。

それから、testerを使ってウィジェットとやり取りすることができます。プロバイダと対話したい場合は、ProviderContainerを取得することもできます。ProviderScope.containerOf(buildContext)を使って取得できます。
tester を使うことで、以下のように書くことができます：
```dart
final element = tester.element(find.byType(YourWidgetYouWantToTest));
final container = ProviderScope.containerOf(element);
```
そして、それをプロバイダーの読み取りに使うことができる。これがその例だ：
```dart
void main() {
  testWidgets('Some description', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YourWidgetYouWantToTest()),
    );

    final element = tester.element(find.byType(YourWidgetYouWantToTest));
    final container = ProviderScope.containerOf(element);

    // TODO interact with your providers
    expect(
      container.read(provider),
      'some value',
    );
  });
}
```
