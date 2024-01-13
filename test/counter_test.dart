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

    test('カウンターをリセットすると値が０になる', () {
      counter.reset();
      expect(counter.count, 0);
    });
  });
}
