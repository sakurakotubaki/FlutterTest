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
