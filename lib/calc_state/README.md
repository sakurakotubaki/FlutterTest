# RiverpodでUnit Testをしてみた!

## 読んでほしい人
- riverpod2.0でUnit Testを書いてみたい人.
- 簡単なテストを書いてみたい.
- テストコードを書いてみたことあるひと.

## 補足情報
必要なパッケージを追加しておいてください

riverpod:
```bash
flutter pub add \
flutter_riverpod \
riverpod_annotation \
dev:riverpod_generator \
dev:build_runner \
dev:custom_lint \
dev:riverpod_lint
```

freezed:
```bash
flutter pub add \
  freezed_annotation \
  --dev build_runner \
  --dev freezed \
  json_annotation \
  --dev json_serializable
```

## 記事の内容
今回は、電卓をイメージしたビジネスロジックを想定して、Unit Testを書いてみました。
参考にしたブログがあったのですが、中途半端なソースコードだったので、書いてないメソッドを追加して、`riverpod generator` + `Freezed`の技術構成で私なりに、テストコードを書いてみました。

まずは、値を保持するモデルクラスを定義します。値の保存と状態を扱うのに使います。
:::details CalcState
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'calc_state.freezed.dart';
part 'calc_state.g.dart';

@freezed
class CalcState with _$CalcState {
  const factory CalcState({
    required String text,
  }) = _CalcState;

  factory CalcState.fromJson(Map<String, Object?> json)
      => _$CalcStateFromJson(json);
}
```
:::

Unit Testで使う電卓をイメージしたビジネスロジックを書いたコードです。

:::details CalcController
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testing_example/calc_state/model/calc_state.dart';
part 'calc_controller.g.dart';

@riverpod
class CalcController extends _$CalcController {

  @override
  CalcState build() {
    return const CalcState(text: '0');
  }

  void input(String input) {
    // 0の時は先頭に0をつけない
    if(state.text == "0") {
      state = state.copyWith(text: input);
    } else {
    // 0以外の時は入力した文字を後ろにつける
      state = state.copyWith(text: state.text + input);
    }
  }
  // debugStateは、stateを返すだけのメソッド
  CalcState debugState() {
    return state;
  }
}
```
:::

:::details テストコード
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_example/calc_state/usecase/calc_controller.dart';

void main() {
  // テスト対象のクラスを宣言
  late CalcController target;
  // テスト対象のクラスを初期化
  setUp(() {
    // ProviderContainerを作成
    final container = ProviderContainer();
    // ProviderContainerにCalcControllerを登録
    target = container.read(calcControllerProvider.notifier);
  });
  // テストをグループ化
  group("電卓のUnit Test -", () {
    test("riverpod test1", () {
      // expectは、第一引数と第二引数が一致するかどうかを判定する
      expect(target.debugState().text, "0");
      // inputメソッドを呼び出す
      target.input("1");// 1を入力
      target.input("5");// 5を入力
      expect(target.debugState().text, "15");// 15になっているかチェック
    });

    test("riverpod test2", () {
      expect(target.debugState().text, "0");
      // inputメソッドを呼び出す
      target.input("2");// 2を入力
      target.input("3");// 3を入力
      target.input("4");// 4を入力
      expect(target.debugState().text, "234");// 234になっているかチェック
    });
  });
}
```
:::

## 最後に
今回は、電卓のビジネスロジックを想定して、Unit Testを書いてみました。簡単なのかわからないですが、テストについて解説をしてみました。テストコードの学習の参考になる海外の動画のリンクも貼っておきます。日本語の字幕つけてみて見てください。
https://www.youtube.com/watch?v=mxTW020pyuc

riverpodのテストについて詳しく知りたい方はこちらを読んでください。
https://riverpod.dev/ja/docs/essentials/testing

### 公式を翻訳
Riverpod APIの中核となるのは、プロバイダを単独でテストできる機能です。

適切なテストスイートには、克服すべき課題がいくつかあります：

テストは状態を共有してはなりません。これは、新しいテストが以前のテストの影響を受けないようにすることを意味します。
テストは、特定の機能性をモックして望ましい状態を実現できるようにすべきである。
テスト環境は、可能な限り実環境に近づける。
幸いなことに、Riverpodはこれらすべての目標を簡単に達成することができます。

テストの設定
Riverpodでテストを定義する場合、主に2つのシナリオがあります：

ユニットテスト、通常はFlutterに依存しない。これは、プロバイダの動作を単独でテストするのに便利です。
ウィジェットテスト、通常はFlutter依存関係を持つ。これは、プロバイダを使用するウィジェットの動作をテストするのに便利です。

ユニットテスト
ユニットテストは、package:test の test 関数を使って定義します。

他のテストとの主な違いは、ProviderContainer オブジェクトを作成することです。このオブジェクトによって、テストはプロバイダとやりとりできるようになります。

ProviderContainer オブジェクトの作成と破棄の両方を行うテスト・ユーティリティを作成することをお勧めします：
```dart
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}
```
そして、このユーティリティを使ってテストを定義することができる：
```dart
void main() {
  test('Some description', () {
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    final container = createContainer();

    // TODO: use the container to test your application.
    expect(
      container.read(provider),
      equals('some value'),
    );
  });
}
```

ProviderContainerができたので、それを使ってプロバイダーを読み込むことができます：

container.read：プロバイダーの現在の値を読み取る。
container.listen：プロバイダーをリッスンし、変更の通知を受ける。
