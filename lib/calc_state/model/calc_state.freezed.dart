// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calc_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CalcState _$CalcStateFromJson(Map<String, dynamic> json) {
  return _CalcState.fromJson(json);
}

/// @nodoc
mixin _$CalcState {
  String get text => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CalcStateCopyWith<CalcState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalcStateCopyWith<$Res> {
  factory $CalcStateCopyWith(CalcState value, $Res Function(CalcState) then) =
      _$CalcStateCopyWithImpl<$Res, CalcState>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$CalcStateCopyWithImpl<$Res, $Val extends CalcState>
    implements $CalcStateCopyWith<$Res> {
  _$CalcStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalcStateImplCopyWith<$Res>
    implements $CalcStateCopyWith<$Res> {
  factory _$$CalcStateImplCopyWith(
          _$CalcStateImpl value, $Res Function(_$CalcStateImpl) then) =
      __$$CalcStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$CalcStateImplCopyWithImpl<$Res>
    extends _$CalcStateCopyWithImpl<$Res, _$CalcStateImpl>
    implements _$$CalcStateImplCopyWith<$Res> {
  __$$CalcStateImplCopyWithImpl(
      _$CalcStateImpl _value, $Res Function(_$CalcStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_$CalcStateImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalcStateImpl with DiagnosticableTreeMixin implements _CalcState {
  const _$CalcStateImpl({required this.text});

  factory _$CalcStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalcStateImplFromJson(json);

  @override
  final String text;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalcState(text: $text)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalcState'))
      ..add(DiagnosticsProperty('text', text));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalcStateImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalcStateImplCopyWith<_$CalcStateImpl> get copyWith =>
      __$$CalcStateImplCopyWithImpl<_$CalcStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalcStateImplToJson(
      this,
    );
  }
}

abstract class _CalcState implements CalcState {
  const factory _CalcState({required final String text}) = _$CalcStateImpl;

  factory _CalcState.fromJson(Map<String, dynamic> json) =
      _$CalcStateImpl.fromJson;

  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$CalcStateImplCopyWith<_$CalcStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
