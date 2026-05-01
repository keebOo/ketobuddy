// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keto_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KetoScore {
  int get score => throw _privateConstructorUsedError;
  ScoreLabel get label => throw _privateConstructorUsedError;
  double? get netCarbs => throw _privateConstructorUsedError;
  bool get hasEnoughData => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;

  /// Create a copy of KetoScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KetoScoreCopyWith<KetoScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KetoScoreCopyWith<$Res> {
  factory $KetoScoreCopyWith(KetoScore value, $Res Function(KetoScore) then) =
      _$KetoScoreCopyWithImpl<$Res, KetoScore>;
  @useResult
  $Res call({
    int score,
    ScoreLabel label,
    double? netCarbs,
    bool hasEnoughData,
    List<String> warnings,
  });
}

/// @nodoc
class _$KetoScoreCopyWithImpl<$Res, $Val extends KetoScore>
    implements $KetoScoreCopyWith<$Res> {
  _$KetoScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KetoScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? label = null,
    Object? netCarbs = freezed,
    Object? hasEnoughData = null,
    Object? warnings = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as ScoreLabel,
            netCarbs: freezed == netCarbs
                ? _value.netCarbs
                : netCarbs // ignore: cast_nullable_to_non_nullable
                      as double?,
            hasEnoughData: null == hasEnoughData
                ? _value.hasEnoughData
                : hasEnoughData // ignore: cast_nullable_to_non_nullable
                      as bool,
            warnings: null == warnings
                ? _value.warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KetoScoreImplCopyWith<$Res>
    implements $KetoScoreCopyWith<$Res> {
  factory _$$KetoScoreImplCopyWith(
    _$KetoScoreImpl value,
    $Res Function(_$KetoScoreImpl) then,
  ) = __$$KetoScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int score,
    ScoreLabel label,
    double? netCarbs,
    bool hasEnoughData,
    List<String> warnings,
  });
}

/// @nodoc
class __$$KetoScoreImplCopyWithImpl<$Res>
    extends _$KetoScoreCopyWithImpl<$Res, _$KetoScoreImpl>
    implements _$$KetoScoreImplCopyWith<$Res> {
  __$$KetoScoreImplCopyWithImpl(
    _$KetoScoreImpl _value,
    $Res Function(_$KetoScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KetoScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? label = null,
    Object? netCarbs = freezed,
    Object? hasEnoughData = null,
    Object? warnings = null,
  }) {
    return _then(
      _$KetoScoreImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as ScoreLabel,
        netCarbs: freezed == netCarbs
            ? _value.netCarbs
            : netCarbs // ignore: cast_nullable_to_non_nullable
                  as double?,
        hasEnoughData: null == hasEnoughData
            ? _value.hasEnoughData
            : hasEnoughData // ignore: cast_nullable_to_non_nullable
                  as bool,
        warnings: null == warnings
            ? _value._warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$KetoScoreImpl implements _KetoScore {
  const _$KetoScoreImpl({
    required this.score,
    required this.label,
    this.netCarbs,
    required this.hasEnoughData,
    required final List<String> warnings,
  }) : _warnings = warnings;

  @override
  final int score;
  @override
  final ScoreLabel label;
  @override
  final double? netCarbs;
  @override
  final bool hasEnoughData;
  final List<String> _warnings;
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  String toString() {
    return 'KetoScore(score: $score, label: $label, netCarbs: $netCarbs, hasEnoughData: $hasEnoughData, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KetoScoreImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.netCarbs, netCarbs) ||
                other.netCarbs == netCarbs) &&
            (identical(other.hasEnoughData, hasEnoughData) ||
                other.hasEnoughData == hasEnoughData) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    label,
    netCarbs,
    hasEnoughData,
    const DeepCollectionEquality().hash(_warnings),
  );

  /// Create a copy of KetoScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KetoScoreImplCopyWith<_$KetoScoreImpl> get copyWith =>
      __$$KetoScoreImplCopyWithImpl<_$KetoScoreImpl>(this, _$identity);
}

abstract class _KetoScore implements KetoScore {
  const factory _KetoScore({
    required final int score,
    required final ScoreLabel label,
    final double? netCarbs,
    required final bool hasEnoughData,
    required final List<String> warnings,
  }) = _$KetoScoreImpl;

  @override
  int get score;
  @override
  ScoreLabel get label;
  @override
  double? get netCarbs;
  @override
  bool get hasEnoughData;
  @override
  List<String> get warnings;

  /// Create a copy of KetoScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KetoScoreImplCopyWith<_$KetoScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
