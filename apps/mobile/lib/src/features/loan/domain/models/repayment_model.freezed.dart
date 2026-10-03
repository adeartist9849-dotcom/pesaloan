// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repayment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RepaymentDetailModel _$RepaymentDetailModelFromJson(Map<String, dynamic> json) {
  return _RepaymentDetailModel.fromJson(json);
}

/// @nodoc
mixin _$RepaymentDetailModel {
  String get loanId => throw _privateConstructorUsedError;
  int get outstandingBalance => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get principal => throw _privateConstructorUsedError;
  int get interest => throw _privateConstructorUsedError;
  int get fees => throw _privateConstructorUsedError;
  int get totalPayable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RepaymentDetailModelCopyWith<RepaymentDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepaymentDetailModelCopyWith<$Res> {
  factory $RepaymentDetailModelCopyWith(RepaymentDetailModel value,
          $Res Function(RepaymentDetailModel) then) =
      _$RepaymentDetailModelCopyWithImpl<$Res, RepaymentDetailModel>;
  @useResult
  $Res call(
      {String loanId,
      int outstandingBalance,
      DateTime dueDate,
      String status,
      int principal,
      int interest,
      int fees,
      int totalPayable});
}

/// @nodoc
class _$RepaymentDetailModelCopyWithImpl<$Res,
        $Val extends RepaymentDetailModel>
    implements $RepaymentDetailModelCopyWith<$Res> {
  _$RepaymentDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loanId = null,
    Object? outstandingBalance = null,
    Object? dueDate = null,
    Object? status = null,
    Object? principal = null,
    Object? interest = null,
    Object? fees = null,
    Object? totalPayable = null,
  }) {
    return _then(_value.copyWith(
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      principal: null == principal
          ? _value.principal
          : principal // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RepaymentDetailModelImplCopyWith<$Res>
    implements $RepaymentDetailModelCopyWith<$Res> {
  factory _$$RepaymentDetailModelImplCopyWith(_$RepaymentDetailModelImpl value,
          $Res Function(_$RepaymentDetailModelImpl) then) =
      __$$RepaymentDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String loanId,
      int outstandingBalance,
      DateTime dueDate,
      String status,
      int principal,
      int interest,
      int fees,
      int totalPayable});
}

/// @nodoc
class __$$RepaymentDetailModelImplCopyWithImpl<$Res>
    extends _$RepaymentDetailModelCopyWithImpl<$Res, _$RepaymentDetailModelImpl>
    implements _$$RepaymentDetailModelImplCopyWith<$Res> {
  __$$RepaymentDetailModelImplCopyWithImpl(_$RepaymentDetailModelImpl _value,
      $Res Function(_$RepaymentDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loanId = null,
    Object? outstandingBalance = null,
    Object? dueDate = null,
    Object? status = null,
    Object? principal = null,
    Object? interest = null,
    Object? fees = null,
    Object? totalPayable = null,
  }) {
    return _then(_$RepaymentDetailModelImpl(
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      principal: null == principal
          ? _value.principal
          : principal // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RepaymentDetailModelImpl implements _RepaymentDetailModel {
  const _$RepaymentDetailModelImpl(
      {required this.loanId,
      required this.outstandingBalance,
      required this.dueDate,
      required this.status,
      required this.principal,
      required this.interest,
      required this.fees,
      required this.totalPayable});

  factory _$RepaymentDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepaymentDetailModelImplFromJson(json);

  @override
  final String loanId;
  @override
  final int outstandingBalance;
  @override
  final DateTime dueDate;
  @override
  final String status;
  @override
  final int principal;
  @override
  final int interest;
  @override
  final int fees;
  @override
  final int totalPayable;

  @override
  String toString() {
    return 'RepaymentDetailModel(loanId: $loanId, outstandingBalance: $outstandingBalance, dueDate: $dueDate, status: $status, principal: $principal, interest: $interest, fees: $fees, totalPayable: $totalPayable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepaymentDetailModelImpl &&
            (identical(other.loanId, loanId) || other.loanId == loanId) &&
            (identical(other.outstandingBalance, outstandingBalance) ||
                other.outstandingBalance == outstandingBalance) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.principal, principal) ||
                other.principal == principal) &&
            (identical(other.interest, interest) ||
                other.interest == interest) &&
            (identical(other.fees, fees) || other.fees == fees) &&
            (identical(other.totalPayable, totalPayable) ||
                other.totalPayable == totalPayable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, loanId, outstandingBalance,
      dueDate, status, principal, interest, fees, totalPayable);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RepaymentDetailModelImplCopyWith<_$RepaymentDetailModelImpl>
      get copyWith =>
          __$$RepaymentDetailModelImplCopyWithImpl<_$RepaymentDetailModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepaymentDetailModelImplToJson(
      this,
    );
  }
}

abstract class _RepaymentDetailModel implements RepaymentDetailModel {
  const factory _RepaymentDetailModel(
      {required final String loanId,
      required final int outstandingBalance,
      required final DateTime dueDate,
      required final String status,
      required final int principal,
      required final int interest,
      required final int fees,
      required final int totalPayable}) = _$RepaymentDetailModelImpl;

  factory _RepaymentDetailModel.fromJson(Map<String, dynamic> json) =
      _$RepaymentDetailModelImpl.fromJson;

  @override
  String get loanId;
  @override
  int get outstandingBalance;
  @override
  DateTime get dueDate;
  @override
  String get status;
  @override
  int get principal;
  @override
  int get interest;
  @override
  int get fees;
  @override
  int get totalPayable;
  @override
  @JsonKey(ignore: true)
  _$$RepaymentDetailModelImplCopyWith<_$RepaymentDetailModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
