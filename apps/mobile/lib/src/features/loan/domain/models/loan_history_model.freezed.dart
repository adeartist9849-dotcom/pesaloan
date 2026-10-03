// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanHistoryModel _$LoanHistoryModelFromJson(Map<String, dynamic> json) {
  return _LoanHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$LoanHistoryModel {
  String get id => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  DateTime? get disbursedAt => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanHistoryModelCopyWith<LoanHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanHistoryModelCopyWith<$Res> {
  factory $LoanHistoryModelCopyWith(
          LoanHistoryModel value, $Res Function(LoanHistoryModel) then) =
      _$LoanHistoryModelCopyWithImpl<$Res, LoanHistoryModel>;
  @useResult
  $Res call(
      {String id,
      int amount,
      String status,
      DateTime dueDate,
      DateTime? disbursedAt,
      DateTime? paidAt});
}

/// @nodoc
class _$LoanHistoryModelCopyWithImpl<$Res, $Val extends LoanHistoryModel>
    implements $LoanHistoryModelCopyWith<$Res> {
  _$LoanHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? status = null,
    Object? dueDate = null,
    Object? disbursedAt = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      disbursedAt: freezed == disbursedAt
          ? _value.disbursedAt
          : disbursedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanHistoryModelImplCopyWith<$Res>
    implements $LoanHistoryModelCopyWith<$Res> {
  factory _$$LoanHistoryModelImplCopyWith(_$LoanHistoryModelImpl value,
          $Res Function(_$LoanHistoryModelImpl) then) =
      __$$LoanHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int amount,
      String status,
      DateTime dueDate,
      DateTime? disbursedAt,
      DateTime? paidAt});
}

/// @nodoc
class __$$LoanHistoryModelImplCopyWithImpl<$Res>
    extends _$LoanHistoryModelCopyWithImpl<$Res, _$LoanHistoryModelImpl>
    implements _$$LoanHistoryModelImplCopyWith<$Res> {
  __$$LoanHistoryModelImplCopyWithImpl(_$LoanHistoryModelImpl _value,
      $Res Function(_$LoanHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? status = null,
    Object? dueDate = null,
    Object? disbursedAt = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_$LoanHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      disbursedAt: freezed == disbursedAt
          ? _value.disbursedAt
          : disbursedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanHistoryModelImpl implements _LoanHistoryModel {
  const _$LoanHistoryModelImpl(
      {required this.id,
      required this.amount,
      required this.status,
      required this.dueDate,
      this.disbursedAt,
      this.paidAt});

  factory _$LoanHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final int amount;
  @override
  final String status;
  @override
  final DateTime dueDate;
  @override
  final DateTime? disbursedAt;
  @override
  final DateTime? paidAt;

  @override
  String toString() {
    return 'LoanHistoryModel(id: $id, amount: $amount, status: $status, dueDate: $dueDate, disbursedAt: $disbursedAt, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.disbursedAt, disbursedAt) ||
                other.disbursedAt == disbursedAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, amount, status, dueDate, disbursedAt, paidAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanHistoryModelImplCopyWith<_$LoanHistoryModelImpl> get copyWith =>
      __$$LoanHistoryModelImplCopyWithImpl<_$LoanHistoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _LoanHistoryModel implements LoanHistoryModel {
  const factory _LoanHistoryModel(
      {required final String id,
      required final int amount,
      required final String status,
      required final DateTime dueDate,
      final DateTime? disbursedAt,
      final DateTime? paidAt}) = _$LoanHistoryModelImpl;

  factory _LoanHistoryModel.fromJson(Map<String, dynamic> json) =
      _$LoanHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  int get amount;
  @override
  String get status;
  @override
  DateTime get dueDate;
  @override
  DateTime? get disbursedAt;
  @override
  DateTime? get paidAt;
  @override
  @JsonKey(ignore: true)
  _$$LoanHistoryModelImplCopyWith<_$LoanHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
