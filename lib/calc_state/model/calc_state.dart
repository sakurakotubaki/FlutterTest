// This file is "main.dart"
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
