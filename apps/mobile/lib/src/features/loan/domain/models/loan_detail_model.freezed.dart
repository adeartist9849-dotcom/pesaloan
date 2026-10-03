// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanDetailModel _$LoanDetailModelFromJson(Map<String, dynamic> json) {
  return _LoanDetailModel.fromJson(json);
}

/// @nodoc
mixin _$LoanDetailModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get applicationId => throw _privateConstructorUsedError;
  int get principal => throw _privateConstructorUsedError;
  int get interest => throw _privateConstructorUsedError;
  int get fees => throw _privateConstructorUsedError;
  int get totalPayable => throw _privateConstructorUsedError;
  int get termDays => throw _privateConstructorUsedError;
  int get disbursedAmount => throw _privateConstructorUsedError;
  int get outstandingBalance => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get disbursedAt => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  String get agreementVersion => throw _privateConstructorUsedError;
  DateTime? get agreementAcceptedAt => throw _privateConstructorUsedError;
  List<TransactionModel> get transactions => throw _privateConstructorUsedError;
  List<RepaymentModel> get repayments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanDetailModelCopyWith<LoanDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanDetailModelCopyWith<$Res> {
  factory $LoanDetailModelCopyWith(
          LoanDetailModel value, $Res Function(LoanDetailModel) then) =
      _$LoanDetailModelCopyWithImpl<$Res, LoanDetailModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String applicationId,
      int principal,
      int interest,
      int fees,
      int totalPayable,
      int termDays,
      int disbursedAmount,
      int outstandingBalance,
      String status,
      DateTime? disbursedAt,
      DateTime dueDate,
      DateTime? paidAt,
      String agreementVersion,
      DateTime? agreementAcceptedAt,
      List<TransactionModel> transactions,
      List<RepaymentModel> repayments});
}

/// @nodoc
class _$LoanDetailModelCopyWithImpl<$Res, $Val extends LoanDetailModel>
    implements $LoanDetailModelCopyWith<$Res> {
  _$LoanDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? applicationId = null,
    Object? principal = null,
    Object? interest = null,
    Object? fees = null,
    Object? totalPayable = null,
    Object? termDays = null,
    Object? disbursedAmount = null,
    Object? outstandingBalance = null,
    Object? status = null,
    Object? disbursedAt = freezed,
    Object? dueDate = null,
    Object? paidAt = freezed,
    Object? agreementVersion = null,
    Object? agreementAcceptedAt = freezed,
    Object? transactions = null,
    Object? repayments = null,
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
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
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
      termDays: null == termDays
          ? _value.termDays
          : termDays // ignore: cast_nullable_to_non_nullable
              as int,
      disbursedAmount: null == disbursedAmount
          ? _value.disbursedAmount
          : disbursedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      disbursedAt: freezed == disbursedAt
          ? _value.disbursedAt
          : disbursedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      agreementVersion: null == agreementVersion
          ? _value.agreementVersion
          : agreementVersion // ignore: cast_nullable_to_non_nullable
              as String,
      agreementAcceptedAt: freezed == agreementAcceptedAt
          ? _value.agreementAcceptedAt
          : agreementAcceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionModel>,
      repayments: null == repayments
          ? _value.repayments
          : repayments // ignore: cast_nullable_to_non_nullable
              as List<RepaymentModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanDetailModelImplCopyWith<$Res>
    implements $LoanDetailModelCopyWith<$Res> {
  factory _$$LoanDetailModelImplCopyWith(_$LoanDetailModelImpl value,
          $Res Function(_$LoanDetailModelImpl) then) =
      __$$LoanDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String applicationId,
      int principal,
      int interest,
      int fees,
      int totalPayable,
      int termDays,
      int disbursedAmount,
      int outstandingBalance,
      String status,
      DateTime? disbursedAt,
      DateTime dueDate,
      DateTime? paidAt,
      String agreementVersion,
      DateTime? agreementAcceptedAt,
      List<TransactionModel> transactions,
      List<RepaymentModel> repayments});
}

/// @nodoc
class __$$LoanDetailModelImplCopyWithImpl<$Res>
    extends _$LoanDetailModelCopyWithImpl<$Res, _$LoanDetailModelImpl>
    implements _$$LoanDetailModelImplCopyWith<$Res> {
  __$$LoanDetailModelImplCopyWithImpl(
      _$LoanDetailModelImpl _value, $Res Function(_$LoanDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? applicationId = null,
    Object? principal = null,
    Object? interest = null,
    Object? fees = null,
    Object? totalPayable = null,
    Object? termDays = null,
    Object? disbursedAmount = null,
    Object? outstandingBalance = null,
    Object? status = null,
    Object? disbursedAt = freezed,
    Object? dueDate = null,
    Object? paidAt = freezed,
    Object? agreementVersion = null,
    Object? agreementAcceptedAt = freezed,
    Object? transactions = null,
    Object? repayments = null,
  }) {
    return _then(_$LoanDetailModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
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
      termDays: null == termDays
          ? _value.termDays
          : termDays // ignore: cast_nullable_to_non_nullable
              as int,
      disbursedAmount: null == disbursedAmount
          ? _value.disbursedAmount
          : disbursedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      disbursedAt: freezed == disbursedAt
          ? _value.disbursedAt
          : disbursedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      agreementVersion: null == agreementVersion
          ? _value.agreementVersion
          : agreementVersion // ignore: cast_nullable_to_non_nullable
              as String,
      agreementAcceptedAt: freezed == agreementAcceptedAt
          ? _value.agreementAcceptedAt
          : agreementAcceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionModel>,
      repayments: null == repayments
          ? _value._repayments
          : repayments // ignore: cast_nullable_to_non_nullable
              as List<RepaymentModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanDetailModelImpl implements _LoanDetailModel {
  const _$LoanDetailModelImpl(
      {required this.id,
      required this.userId,
      required this.applicationId,
      required this.principal,
      required this.interest,
      required this.fees,
      required this.totalPayable,
      required this.termDays,
      required this.disbursedAmount,
      required this.outstandingBalance,
      required this.status,
      this.disbursedAt,
      required this.dueDate,
      this.paidAt,
      required this.agreementVersion,
      this.agreementAcceptedAt,
      required final List<TransactionModel> transactions,
      required final List<RepaymentModel> repayments})
      : _transactions = transactions,
        _repayments = repayments;

  factory _$LoanDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanDetailModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String applicationId;
  @override
  final int principal;
  @override
  final int interest;
  @override
  final int fees;
  @override
  final int totalPayable;
  @override
  final int termDays;
  @override
  final int disbursedAmount;
  @override
  final int outstandingBalance;
  @override
  final String status;
  @override
  final DateTime? disbursedAt;
  @override
  final DateTime dueDate;
  @override
  final DateTime? paidAt;
  @override
  final String agreementVersion;
  @override
  final DateTime? agreementAcceptedAt;
  final List<TransactionModel> _transactions;
  @override
  List<TransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  final List<RepaymentModel> _repayments;
  @override
  List<RepaymentModel> get repayments {
    if (_repayments is EqualUnmodifiableListView) return _repayments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_repayments);
  }

  @override
  String toString() {
    return 'LoanDetailModel(id: $id, userId: $userId, applicationId: $applicationId, principal: $principal, interest: $interest, fees: $fees, totalPayable: $totalPayable, termDays: $termDays, disbursedAmount: $disbursedAmount, outstandingBalance: $outstandingBalance, status: $status, disbursedAt: $disbursedAt, dueDate: $dueDate, paidAt: $paidAt, agreementVersion: $agreementVersion, agreementAcceptedAt: $agreementAcceptedAt, transactions: $transactions, repayments: $repayments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.principal, principal) ||
                other.principal == principal) &&
            (identical(other.interest, interest) ||
                other.interest == interest) &&
            (identical(other.fees, fees) || other.fees == fees) &&
            (identical(other.totalPayable, totalPayable) ||
                other.totalPayable == totalPayable) &&
            (identical(other.termDays, termDays) ||
                other.termDays == termDays) &&
            (identical(other.disbursedAmount, disbursedAmount) ||
                other.disbursedAmount == disbursedAmount) &&
            (identical(other.outstandingBalance, outstandingBalance) ||
                other.outstandingBalance == outstandingBalance) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.disbursedAt, disbursedAt) ||
                other.disbursedAt == disbursedAt) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.agreementVersion, agreementVersion) ||
                other.agreementVersion == agreementVersion) &&
            (identical(other.agreementAcceptedAt, agreementAcceptedAt) ||
                other.agreementAcceptedAt == agreementAcceptedAt) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            const DeepCollectionEquality()
                .equals(other._repayments, _repayments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      applicationId,
      principal,
      interest,
      fees,
      totalPayable,
      termDays,
      disbursedAmount,
      outstandingBalance,
      status,
      disbursedAt,
      dueDate,
      paidAt,
      agreementVersion,
      agreementAcceptedAt,
      const DeepCollectionEquality().hash(_transactions),
      const DeepCollectionEquality().hash(_repayments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanDetailModelImplCopyWith<_$LoanDetailModelImpl> get copyWith =>
      __$$LoanDetailModelImplCopyWithImpl<_$LoanDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanDetailModelImplToJson(
      this,
    );
  }
}

abstract class _LoanDetailModel implements LoanDetailModel {
  const factory _LoanDetailModel(
      {required final String id,
      required final String userId,
      required final String applicationId,
      required final int principal,
      required final int interest,
      required final int fees,
      required final int totalPayable,
      required final int termDays,
      required final int disbursedAmount,
      required final int outstandingBalance,
      required final String status,
      final DateTime? disbursedAt,
      required final DateTime dueDate,
      final DateTime? paidAt,
      required final String agreementVersion,
      final DateTime? agreementAcceptedAt,
      required final List<TransactionModel> transactions,
      required final List<RepaymentModel> repayments}) = _$LoanDetailModelImpl;

  factory _LoanDetailModel.fromJson(Map<String, dynamic> json) =
      _$LoanDetailModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get applicationId;
  @override
  int get principal;
  @override
  int get interest;
  @override
  int get fees;
  @override
  int get totalPayable;
  @override
  int get termDays;
  @override
  int get disbursedAmount;
  @override
  int get outstandingBalance;
  @override
  String get status;
  @override
  DateTime? get disbursedAt;
  @override
  DateTime get dueDate;
  @override
  DateTime? get paidAt;
  @override
  String get agreementVersion;
  @override
  DateTime? get agreementAcceptedAt;
  @override
  List<TransactionModel> get transactions;
  @override
  List<RepaymentModel> get repayments;
  @override
  @JsonKey(ignore: true)
  _$$LoanDetailModelImplCopyWith<_$LoanDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  String get id => throw _privateConstructorUsedError;
  String get loanId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;
  String? get providerReference => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime? get processedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call(
      {String id,
      String loanId,
      String userId,
      String type,
      int amount,
      String status,
      String reference,
      String? provider,
      String? providerReference,
      String description,
      Map<String, dynamic> metadata,
      DateTime? processedAt,
      DateTime createdAt});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loanId = null,
    Object? userId = null,
    Object? type = null,
    Object? amount = null,
    Object? status = null,
    Object? reference = null,
    Object? provider = freezed,
    Object? providerReference = freezed,
    Object? description = null,
    Object? metadata = null,
    Object? processedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerReference: freezed == providerReference
          ? _value.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String loanId,
      String userId,
      String type,
      int amount,
      String status,
      String reference,
      String? provider,
      String? providerReference,
      String description,
      Map<String, dynamic> metadata,
      DateTime? processedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loanId = null,
    Object? userId = null,
    Object? type = null,
    Object? amount = null,
    Object? status = null,
    Object? reference = null,
    Object? provider = freezed,
    Object? providerReference = freezed,
    Object? description = null,
    Object? metadata = null,
    Object? processedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TransactionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerReference: freezed == providerReference
          ? _value.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl(
      {required this.id,
      required this.loanId,
      required this.userId,
      required this.type,
      required this.amount,
      required this.status,
      required this.reference,
      this.provider,
      this.providerReference,
      required this.description,
      required final Map<String, dynamic> metadata,
      this.processedAt,
      required this.createdAt})
      : _metadata = metadata;

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String loanId;
  @override
  final String userId;
  @override
  final String type;
  @override
  final int amount;
  @override
  final String status;
  @override
  final String reference;
  @override
  final String? provider;
  @override
  final String? providerReference;
  @override
  final String description;
  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime? processedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TransactionModel(id: $id, loanId: $loanId, userId: $userId, type: $type, amount: $amount, status: $status, reference: $reference, provider: $provider, providerReference: $providerReference, description: $description, metadata: $metadata, processedAt: $processedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.loanId, loanId) || other.loanId == loanId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerReference, providerReference) ||
                other.providerReference == providerReference) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      loanId,
      userId,
      type,
      amount,
      status,
      reference,
      provider,
      providerReference,
      description,
      const DeepCollectionEquality().hash(_metadata),
      processedAt,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel(
      {required final String id,
      required final String loanId,
      required final String userId,
      required final String type,
      required final int amount,
      required final String status,
      required final String reference,
      final String? provider,
      final String? providerReference,
      required final String description,
      required final Map<String, dynamic> metadata,
      final DateTime? processedAt,
      required final DateTime createdAt}) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get loanId;
  @override
  String get userId;
  @override
  String get type;
  @override
  int get amount;
  @override
  String get status;
  @override
  String get reference;
  @override
  String? get provider;
  @override
  String? get providerReference;
  @override
  String get description;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime? get processedAt;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RepaymentModel _$RepaymentModelFromJson(Map<String, dynamic> json) {
  return _RepaymentModel.fromJson(json);
}

/// @nodoc
mixin _$RepaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get loanId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get transactionReference => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String? get providerTransactionId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  String? get failedReason => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RepaymentModelCopyWith<RepaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepaymentModelCopyWith<$Res> {
  factory $RepaymentModelCopyWith(
          RepaymentModel value, $Res Function(RepaymentModel) then) =
      _$RepaymentModelCopyWithImpl<$Res, RepaymentModel>;
  @useResult
  $Res call(
      {String id,
      String loanId,
      String userId,
      int amount,
      String transactionReference,
      String provider,
      String? providerTransactionId,
      String status,
      DateTime? paidAt,
      String? failedReason,
      Map<String, dynamic> metadata,
      DateTime createdAt});
}

/// @nodoc
class _$RepaymentModelCopyWithImpl<$Res, $Val extends RepaymentModel>
    implements $RepaymentModelCopyWith<$Res> {
  _$RepaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loanId = null,
    Object? userId = null,
    Object? amount = null,
    Object? transactionReference = null,
    Object? provider = null,
    Object? providerTransactionId = freezed,
    Object? status = null,
    Object? paidAt = freezed,
    Object? failedReason = freezed,
    Object? metadata = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      transactionReference: null == transactionReference
          ? _value.transactionReference
          : transactionReference // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      providerTransactionId: freezed == providerTransactionId
          ? _value.providerTransactionId
          : providerTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedReason: freezed == failedReason
          ? _value.failedReason
          : failedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RepaymentModelImplCopyWith<$Res>
    implements $RepaymentModelCopyWith<$Res> {
  factory _$$RepaymentModelImplCopyWith(_$RepaymentModelImpl value,
          $Res Function(_$RepaymentModelImpl) then) =
      __$$RepaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String loanId,
      String userId,
      int amount,
      String transactionReference,
      String provider,
      String? providerTransactionId,
      String status,
      DateTime? paidAt,
      String? failedReason,
      Map<String, dynamic> metadata,
      DateTime createdAt});
}

/// @nodoc
class __$$RepaymentModelImplCopyWithImpl<$Res>
    extends _$RepaymentModelCopyWithImpl<$Res, _$RepaymentModelImpl>
    implements _$$RepaymentModelImplCopyWith<$Res> {
  __$$RepaymentModelImplCopyWithImpl(
      _$RepaymentModelImpl _value, $Res Function(_$RepaymentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loanId = null,
    Object? userId = null,
    Object? amount = null,
    Object? transactionReference = null,
    Object? provider = null,
    Object? providerTransactionId = freezed,
    Object? status = null,
    Object? paidAt = freezed,
    Object? failedReason = freezed,
    Object? metadata = null,
    Object? createdAt = null,
  }) {
    return _then(_$RepaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      transactionReference: null == transactionReference
          ? _value.transactionReference
          : transactionReference // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      providerTransactionId: freezed == providerTransactionId
          ? _value.providerTransactionId
          : providerTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedReason: freezed == failedReason
          ? _value.failedReason
          : failedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RepaymentModelImpl implements _RepaymentModel {
  const _$RepaymentModelImpl(
      {required this.id,
      required this.loanId,
      required this.userId,
      required this.amount,
      required this.transactionReference,
      required this.provider,
      this.providerTransactionId,
      required this.status,
      this.paidAt,
      this.failedReason,
      required final Map<String, dynamic> metadata,
      required this.createdAt})
      : _metadata = metadata;

  factory _$RepaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String loanId;
  @override
  final String userId;
  @override
  final int amount;
  @override
  final String transactionReference;
  @override
  final String provider;
  @override
  final String? providerTransactionId;
  @override
  final String status;
  @override
  final DateTime? paidAt;
  @override
  final String? failedReason;
  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RepaymentModel(id: $id, loanId: $loanId, userId: $userId, amount: $amount, transactionReference: $transactionReference, provider: $provider, providerTransactionId: $providerTransactionId, status: $status, paidAt: $paidAt, failedReason: $failedReason, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.loanId, loanId) || other.loanId == loanId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionReference, transactionReference) ||
                other.transactionReference == transactionReference) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerTransactionId, providerTransactionId) ||
                other.providerTransactionId == providerTransactionId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.failedReason, failedReason) ||
                other.failedReason == failedReason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      loanId,
      userId,
      amount,
      transactionReference,
      provider,
      providerTransactionId,
      status,
      paidAt,
      failedReason,
      const DeepCollectionEquality().hash(_metadata),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RepaymentModelImplCopyWith<_$RepaymentModelImpl> get copyWith =>
      __$$RepaymentModelImplCopyWithImpl<_$RepaymentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepaymentModelImplToJson(
      this,
    );
  }
}

abstract class _RepaymentModel implements RepaymentModel {
  const factory _RepaymentModel(
      {required final String id,
      required final String loanId,
      required final String userId,
      required final int amount,
      required final String transactionReference,
      required final String provider,
      final String? providerTransactionId,
      required final String status,
      final DateTime? paidAt,
      final String? failedReason,
      required final Map<String, dynamic> metadata,
      required final DateTime createdAt}) = _$RepaymentModelImpl;

  factory _RepaymentModel.fromJson(Map<String, dynamic> json) =
      _$RepaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get loanId;
  @override
  String get userId;
  @override
  int get amount;
  @override
  String get transactionReference;
  @override
  String get provider;
  @override
  String? get providerTransactionId;
  @override
  String get status;
  @override
  DateTime? get paidAt;
  @override
  String? get failedReason;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$RepaymentModelImplCopyWith<_$RepaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
