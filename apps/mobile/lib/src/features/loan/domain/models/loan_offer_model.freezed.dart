// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_offer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanOfferModel _$LoanOfferModelFromJson(Map<String, dynamic> json) {
  return _LoanOfferModel.fromJson(json);
}

/// @nodoc
mixin _$LoanOfferModel {
  String get id => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get termDays => throw _privateConstructorUsedError;
  int get interest => throw _privateConstructorUsedError;
  int get fees => throw _privateConstructorUsedError;
  int get totalPayable => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String get agreementVersion => throw _privateConstructorUsedError;
  String get agreementUrl => throw _privateConstructorUsedError;
  String get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanOfferModelCopyWith<LoanOfferModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanOfferModelCopyWith<$Res> {
  factory $LoanOfferModelCopyWith(
          LoanOfferModel value, $Res Function(LoanOfferModel) then) =
      _$LoanOfferModelCopyWithImpl<$Res, LoanOfferModel>;
  @useResult
  $Res call(
      {String id,
      int amount,
      int termDays,
      int interest,
      int fees,
      int totalPayable,
      DateTime dueDate,
      String agreementVersion,
      String agreementUrl,
      String expiresAt});
}

/// @nodoc
class _$LoanOfferModelCopyWithImpl<$Res, $Val extends LoanOfferModel>
    implements $LoanOfferModelCopyWith<$Res> {
  _$LoanOfferModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? termDays = null,
    Object? interest = null,
    Object? fees = null,
    Object? totalPayable = null,
    Object? dueDate = null,
    Object? agreementVersion = null,
    Object? agreementUrl = null,
    Object? expiresAt = null,
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
      termDays: null == termDays
          ? _value.termDays
          : termDays // ignore: cast_nullable_to_non_nullable
              as int,
      interest: null == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as int,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as int,
      totalPayable: null == totalPayable
          ? _value.totalPayable
          : totalPayable // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      agreementVersion: null == agreementVersion
          ? _value.agreementVersion
          : agreementVersion // ignore: cast_nullable_to_non_nullable
              as String,
      agreementUrl: null == agreementUrl
          ? _value.agreementUrl
          : agreementUrl // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanOfferModelImplCopyWith<$Res>
    implements $LoanOfferModelCopyWith<$Res> {
  factory _$$LoanOfferModelImplCopyWith(_$LoanOfferModelImpl value,
          $Res Function(_$LoanOfferModelImpl) then) =
      __$$LoanOfferModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int amount,
      int termDays,
      int interest,
      int fees,
      int totalPayable,
      DateTime dueDate,
      String agreementVersion,
      String agreementUrl,
      String expiresAt});
}

/// @nodoc
class __$$LoanOfferModelImplCopyWithImpl<$Res>
    extends _$LoanOfferModelCopyWithImpl<$Res, _$LoanOfferModelImpl>
    implements _$$LoanOfferModelImplCopyWith<$Res> {
  __$$LoanOfferModelImplCopyWithImpl(
      _$LoanOfferModelImpl _value, $Res Function(_$LoanOfferModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? termDays = null,
    Object? interest = null,
    Object? fees = null,
    Object? totalPayable = null,
    Object? dueDate = null,
    Object? agreementVersion = null,
    Object? agreementUrl = null,
    Object? expiresAt = null,
  }) {
    return _then(_$LoanOfferModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      termDays: null == termDays
          ? _value.termDays
          : termDays // ignore: cast_nullable_to_non_nullable
              as int,
      interest: null == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as int,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as int,
      totalPayable: null == totalPayable
          ? _value.totalPayable
          : totalPayable // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      agreementVersion: null == agreementVersion
          ? _value.agreementVersion
          : agreementVersion // ignore: cast_nullable_to_non_nullable
              as String,
      agreementUrl: null == agreementUrl
          ? _value.agreementUrl
          : agreementUrl // ignore: cast_nullable_to_non_nullable
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
class _$LoanOfferModelImpl implements _LoanOfferModel {
  const _$LoanOfferModelImpl(
      {required this.id,
      required this.amount,
      required this.termDays,
      required this.interest,
      required this.fees,
      required this.totalPayable,
      required this.dueDate,
      required this.agreementVersion,
      required this.agreementUrl,
      required this.expiresAt});

  factory _$LoanOfferModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanOfferModelImplFromJson(json);

  @override
  final String id;
  @override
  final int amount;
  @override
  final int termDays;
  @override
  final int interest;
  @override
  final int fees;
  @override
  final int totalPayable;
  @override
  final DateTime dueDate;
  @override
  final String agreementVersion;
  @override
  final String agreementUrl;
  @override
  final String expiresAt;

  @override
  String toString() {
    return 'LoanOfferModel(id: $id, amount: $amount, termDays: $termDays, interest: $interest, fees: $fees, totalPayable: $totalPayable, dueDate: $dueDate, agreementVersion: $agreementVersion, agreementUrl: $agreementUrl, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanOfferModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.termDays, termDays) ||
                other.termDays == termDays) &&
            (identical(other.interest, interest) ||
                other.interest == interest) &&
            (identical(other.fees, fees) || other.fees == fees) &&
            (identical(other.totalPayable, totalPayable) ||
                other.totalPayable == totalPayable) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.agreementVersion, agreementVersion) ||
                other.agreementVersion == agreementVersion) &&
            (identical(other.agreementUrl, agreementUrl) ||
                other.agreementUrl == agreementUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, amount, termDays, interest,
      fees, totalPayable, dueDate, agreementVersion, agreementUrl, expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanOfferModelImplCopyWith<_$LoanOfferModelImpl> get copyWith =>
      __$$LoanOfferModelImplCopyWithImpl<_$LoanOfferModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanOfferModelImplToJson(
      this,
    );
  }
}

abstract class _LoanOfferModel implements LoanOfferModel {
  const factory _LoanOfferModel(
      {required final String id,
      required final int amount,
      required final int termDays,
      required final int interest,
      required final int fees,
      required final int totalPayable,
      required final DateTime dueDate,
      required final String agreementVersion,
      required final String agreementUrl,
      required final String expiresAt}) = _$LoanOfferModelImpl;

  factory _LoanOfferModel.fromJson(Map<String, dynamic> json) =
      _$LoanOfferModelImpl.fromJson;

  @override
  String get id;
  @override
  int get amount;
  @override
  int get termDays;
  @override
  int get interest;
  @override
  int get fees;
  @override
  int get totalPayable;
  @override
  DateTime get dueDate;
  @override
  String get agreementVersion;
  @override
  String get agreementUrl;
  @override
  String get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$LoanOfferModelImplCopyWith<_$LoanOfferModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
