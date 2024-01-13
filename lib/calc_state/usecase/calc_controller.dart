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
