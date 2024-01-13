# UnitTest

このコードだと、UIとビジネスロジックが混在しているので、実はテストに適していない!

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

デフォルトのテストコード:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testing_example/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

## UIとビジネスロジックを分ける

ロジックを書いたクラスを書く。これはカプセル化して、外部では使えないようにしている。
```dart
class Counter {
  // 同じクラス内からしかアクセスできないようにする
  int _counter = 0;
  // 外部からは参照のみできるようにする
  int get count => _counter;
  // カウントアップするメソッド
  void increment() {
    _counter++;
  }
}
```

あるCounterクラスに依存した密結合になっているが、UIとロジックの分離はできている。
```dart
import 'package:flutter/material.dart';
import 'package:testing_example/counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Counter counter = Counter();

  void _incrementCounter() {
    setState(() {
      counter.increment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## カウンターをテストする
このコードだとあるクラスに依存しているので、２個目のテストをコメントアウトしないとテストが失敗するが、テストごとにクラスをインスタンス化すると、エラーが起きない!
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/counter.dart';

/// テストコードはテストするファイルに対して、同じディレクトリに`_test.dart`をつけたファイルに書く。

void main() {
  // テストのグループ化をする
  group('カウンタークラス -', () {
    // カウンタークラスのインスタンスを作成
        final counter = Counter();
    test(
      'インスタンス化されたカウンタークラスは０である必要がある',
      () {
        // カウンタークラスのインスタンスのカウントが０であることを確認
        final val = counter.count;
        /* Assert は期待する値と実際の値が一致するかどうかを確認する
      第１引数のactual: 実際の値、第２引数のmatcher: 期待する値
      */
        expect(val, 0);
      },
    );
    // test(
    //   'テストの値は１になるはずです',
    //   () {
    //     // ACT はテスト対象の処理を実行する
    //     counter.increment();
    //     final val = counter.count;
    //     // Assert は期待する値と実際の値が一致するかどうかを確認する
    //     expect(val, 1);
    //   },
    // );

    // テストを成功させるには、２番目のテストで期待する値が1のテストをコメントアウトする
    test('マイナスになると数値が 0 or -1になる', () {
      counter.decrement();
      final val = counter.count;
      expect(val, -1);
    });
  });
}
```

## テストの前に実行する
lateをつけてクラスを遅延させて、setUpでテストの前に実行するパターン。この場合だと全ての
テストは通る。

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/counter.dart';

/// テストコードはテストするファイルに対して、同じディレクトリに`_test.dart`をつけたファイルに書く。

void main() {
  // setUp はテストの前に実行される
  late Counter counter;

  setUp(() {
    counter = Counter();
  });

  // テストのグループ化をする
  group('カウンタークラス -', () {
    test(
      'インスタンス化されたカウンタークラスは０である必要がある',
      () {
        // カウンタークラスのインスタンスのカウントが０であることを確認
        final val = counter.count;
        /* Assert は期待する値と実際の値が一致するかどうかを確認する
      第１引数のactual: 実際の値、第２引数のmatcher: 期待する値
      */
        expect(val, 0);
      },
    );

    test(
      'テストの値は１になるはずです',
      () {
        // ACT はテスト対象の処理を実行する
        counter.increment();
        final val = counter.count;
        // Assert は期待する値と実際の値が一致するかどうかを確認する
        expect(val, 1);
      },
    );

    // テストを成功させるには、２番目のテストで期待する値が1のテストをコメントアウトする
    test('マイナスになると数値が 0 or -1になる', () {
      counter.decrement();
      final val = counter.count;
      expect(val, -1);
    });
  });

  // Post Test はテストの後に実行される
  tearDown(() => null);
  tearDownAll(() => null);
}
```

もし`setUpAll`を使うと、２回目のテストでエラーがでる!

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/counter.dart';

/// テストコードはテストするファイルに対して、同じディレクトリに`_test.dart`をつけたファイルに書く。

void main() {
  // setUp はテストの前に実行される
  late Counter counter;

  setUpAll(() {
    counter = Counter();
  });

  // テストのグループ化をする
  group('カウンタークラス -', () {
    test(
      'インスタンス化されたカウンタークラスは０である必要がある',
      () {
        // カウンタークラスのインスタンスのカウントが０であることを確認
        final val = counter.count;
        /* Assert は期待する値と実際の値が一致するかどうかを確認する
      第１引数のactual: 実際の値、第２引数のmatcher: 期待する値
      */
        expect(val, 0);
      },
    );
    test(
      'テストの値は１になるはずです',
      () {
        // ACT はテスト対象の処理を実行する
        counter.increment();
        final val = counter.count;
        // Assert は期待する値と実際の値が一致するかどうかを確認する
        expect(val, 1);
      },
    );

    // テストを成功させるには、２番目のテストで期待する値が1のテストをコメントアウトする
    test('マイナスになると数値が 0 or -1になる', () {
      counter.decrement();
      final val = counter.count;
      expect(val, -1);
    });
  });

  // Post Test はテストの後に実行される
  tearDown(() => null);
  tearDownAll(() => null);
}
```
