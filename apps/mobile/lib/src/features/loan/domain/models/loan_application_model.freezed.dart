// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanApplicationModel _$LoanApplicationModelFromJson(Map<String, dynamic> json) {
  return _LoanApplicationModel.fromJson(json);
}

/// @nodoc
mixin _$LoanApplicationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get requestedAmount => throw _privateConstructorUsedError;
  int get requestedTermDays => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  String? get decisionReason => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanApplicationModelCopyWith<LoanApplicationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanApplicationModelCopyWith<$Res> {
  factory $LoanApplicationModelCopyWith(LoanApplicationModel value,
          $Res Function(LoanApplicationModel) then) =
      _$LoanApplicationModelCopyWithImpl<$Res, LoanApplicationModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int requestedAmount,
      int requestedTermDays,
      String status,
      int? score,
      String? decisionReason,
      String createdAt,
      String expiresAt});
}

/// @nodoc
class _$LoanApplicationModelCopyWithImpl<$Res,
        $Val extends LoanApplicationModel>
    implements $LoanApplicationModelCopyWith<$Res> {
  _$LoanApplicationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? requestedAmount = null,
    Object? requestedTermDays = null,
    Object? status = null,
    Object? score = freezed,
    Object? decisionReason = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      requestedTermDays: null == requestedTermDays
          ? _value.requestedTermDays
          : requestedTermDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
      decisionReason: freezed == decisionReason
          ? _value.decisionReason
          : decisionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanApplicationModelImplCopyWith<$Res>
    implements $LoanApplicationModelCopyWith<$Res> {
  factory _$$LoanApplicationModelImplCopyWith(_$LoanApplicationModelImpl value,
          $Res Function(_$LoanApplicationModelImpl) then) =
      __$$LoanApplicationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int requestedAmount,
      int requestedTermDays,
      String status,
      int? score,
      String? decisionReason,
      String createdAt,
      String expiresAt});
}

/// @nodoc
class __$$LoanApplicationModelImplCopyWithImpl<$Res>
    extends _$LoanApplicationModelCopyWithImpl<$Res, _$LoanApplicationModelImpl>
    implements _$$LoanApplicationModelImplCopyWith<$Res> {
  __$$LoanApplicationModelImplCopyWithImpl(_$LoanApplicationModelImpl _value,
      $Res Function(_$LoanApplicationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? requestedAmount = null,
    Object? requestedTermDays = null,
    Object? status = null,
    Object? score = freezed,
    Object? decisionReason = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
  }) {
    return _then(_$LoanApplicationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      requestedTermDays: null == requestedTermDays
          ? _value.requestedTermDays
          : requestedTermDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
      decisionReason: freezed == decisionReason
          ? _value.decisionReason
          : decisionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanApplicationModelImpl implements _LoanApplicationModel {
  const _$LoanApplicationModelImpl(
      {required this.id,
      required this.userId,
      required this.requestedAmount,
      required this.requestedTermDays,
      required this.status,
      this.score,
      this.decisionReason,
      required this.createdAt,
      required this.expiresAt});

  factory _$LoanApplicationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanApplicationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int requestedAmount;
  @override
  final int requestedTermDays;
  @override
  final String status;
  @override
  final int? score;
  @override
  final String? decisionReason;
  @override
  final String createdAt;
  @override
  final String expiresAt;

  @override
  String toString() {
    return 'LoanApplicationModel(id: $id, userId: $userId, requestedAmount: $requestedAmount, requestedTermDays: $requestedTermDays, status: $status, score: $score, decisionReason: $decisionReason, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanApplicationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.requestedAmount, requestedAmount) ||
                other.requestedAmount == requestedAmount) &&
            (identical(other.requestedTermDays, requestedTermDays) ||
                other.requestedTermDays == requestedTermDays) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.decisionReason, decisionReason) ||
                other.decisionReason == decisionReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, requestedAmount,
      requestedTermDays, status, score, decisionReason, createdAt, expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanApplicationModelImplCopyWith<_$LoanApplicationModelImpl>
      get copyWith =>
          __$$LoanApplicationModelImplCopyWithImpl<_$LoanApplicationModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanApplicationModelImplToJson(
      this,
    );
  }
}

abstract class _LoanApplicationModel implements LoanApplicationModel {
  const factory _LoanApplicationModel(
      {required final String id,
      required final String userId,
      required final int requestedAmount,
      required final int requestedTermDays,
      required final String status,
      final int? score,
      final String? decisionReason,
      required final String createdAt,
      required final String expiresAt}) = _$LoanApplicationModelImpl;

  factory _LoanApplicationModel.fromJson(Map<String, dynamic> json) =
      _$LoanApplicationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get requestedAmount;
  @override
  int get requestedTermDays;
  @override
  String get status;
  @override
  int? get score;
  @override
  String? get decisionReason;
  @override
  String get createdAt;
  @override
  String get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$LoanApplicationModelImplCopyWith<_$LoanApplicationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
