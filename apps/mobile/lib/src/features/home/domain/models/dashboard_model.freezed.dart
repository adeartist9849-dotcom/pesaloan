// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) {
  return _DashboardModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardModel {
  UserSummaryModel get user => throw _privateConstructorUsedError;
  int get availableLimit => throw _privateConstructorUsedError;
  LoanSummaryModel? get currentLoan => throw _privateConstructorUsedError;
  List<LoanSummaryModel> get recentLoans => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardModelCopyWith<DashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardModelCopyWith<$Res> {
  factory $DashboardModelCopyWith(
          DashboardModel value, $Res Function(DashboardModel) then) =
      _$DashboardModelCopyWithImpl<$Res, DashboardModel>;
  @useResult
  $Res call(
      {UserSummaryModel user,
      int availableLimit,
      LoanSummaryModel? currentLoan,
      List<LoanSummaryModel> recentLoans});

  $UserSummaryModelCopyWith<$Res> get user;
  $LoanSummaryModelCopyWith<$Res>? get currentLoan;
}

/// @nodoc
class _$DashboardModelCopyWithImpl<$Res, $Val extends DashboardModel>
    implements $DashboardModelCopyWith<$Res> {
  _$DashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? availableLimit = null,
    Object? currentLoan = freezed,
    Object? recentLoans = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel,
      availableLimit: null == availableLimit
          ? _value.availableLimit
          : availableLimit // ignore: cast_nullable_to_non_nullable
              as int,
      currentLoan: freezed == currentLoan
          ? _value.currentLoan
          : currentLoan // ignore: cast_nullable_to_non_nullable
              as LoanSummaryModel?,
      recentLoans: null == recentLoans
          ? _value.recentLoans
          : recentLoans // ignore: cast_nullable_to_non_nullable
              as List<LoanSummaryModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res> get user {
    return $UserSummaryModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LoanSummaryModelCopyWith<$Res>? get currentLoan {
    if (_value.currentLoan == null) {
      return null;
    }

    return $LoanSummaryModelCopyWith<$Res>(_value.currentLoan!, (value) {
      return _then(_value.copyWith(currentLoan: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardModelImplCopyWith<$Res>
    implements $DashboardModelCopyWith<$Res> {
  factory _$$DashboardModelImplCopyWith(_$DashboardModelImpl value,
          $Res Function(_$DashboardModelImpl) then) =
      __$$DashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserSummaryModel user,
      int availableLimit,
      LoanSummaryModel? currentLoan,
      List<LoanSummaryModel> recentLoans});

  @override
  $UserSummaryModelCopyWith<$Res> get user;
  @override
  $LoanSummaryModelCopyWith<$Res>? get currentLoan;
}

/// @nodoc
class __$$DashboardModelImplCopyWithImpl<$Res>
    extends _$DashboardModelCopyWithImpl<$Res, _$DashboardModelImpl>
    implements _$$DashboardModelImplCopyWith<$Res> {
  __$$DashboardModelImplCopyWithImpl(
      _$DashboardModelImpl _value, $Res Function(_$DashboardModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? availableLimit = null,
    Object? currentLoan = freezed,
    Object? recentLoans = null,
  }) {
    return _then(_$DashboardModelImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel,
      availableLimit: null == availableLimit
          ? _value.availableLimit
          : availableLimit // ignore: cast_nullable_to_non_nullable
              as int,
      currentLoan: freezed == currentLoan
          ? _value.currentLoan
          : currentLoan // ignore: cast_nullable_to_non_nullable
              as LoanSummaryModel?,
      recentLoans: null == recentLoans
          ? _value._recentLoans
          : recentLoans // ignore: cast_nullable_to_non_nullable
              as List<LoanSummaryModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardModelImpl implements _DashboardModel {
  const _$DashboardModelImpl(
      {required this.user,
      required this.availableLimit,
      this.currentLoan,
      required final List<LoanSummaryModel> recentLoans})
      : _recentLoans = recentLoans;

  factory _$DashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardModelImplFromJson(json);

  @override
  final UserSummaryModel user;
  @override
  final int availableLimit;
  @override
  final LoanSummaryModel? currentLoan;
  final List<LoanSummaryModel> _recentLoans;
  @override
  List<LoanSummaryModel> get recentLoans {
    if (_recentLoans is EqualUnmodifiableListView) return _recentLoans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentLoans);
  }

  @override
  String toString() {
    return 'DashboardModel(user: $user, availableLimit: $availableLimit, currentLoan: $currentLoan, recentLoans: $recentLoans)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.availableLimit, availableLimit) ||
                other.availableLimit == availableLimit) &&
            (identical(other.currentLoan, currentLoan) ||
                other.currentLoan == currentLoan) &&
            const DeepCollectionEquality()
                .equals(other._recentLoans, _recentLoans));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, availableLimit,
      currentLoan, const DeepCollectionEquality().hash(_recentLoans));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardModelImplCopyWith<_$DashboardModelImpl> get copyWith =>
      __$$DashboardModelImplCopyWithImpl<_$DashboardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardModel implements DashboardModel {
  const factory _DashboardModel(
          {required final UserSummaryModel user,
          required final int availableLimit,
          final LoanSummaryModel? currentLoan,
          required final List<LoanSummaryModel> recentLoans}) =
      _$DashboardModelImpl;

  factory _DashboardModel.fromJson(Map<String, dynamic> json) =
      _$DashboardModelImpl.fromJson;

  @override
  UserSummaryModel get user;
  @override
  int get availableLimit;
  @override
  LoanSummaryModel? get currentLoan;
  @override
  List<LoanSummaryModel> get recentLoans;
  @override
  @JsonKey(ignore: true)
  _$$DashboardModelImplCopyWith<_$DashboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSummaryModel _$UserSummaryModelFromJson(Map<String, dynamic> json) {
  return _UserSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$UserSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get loanLimit => throw _privateConstructorUsedError;
  String get kycStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSummaryModelCopyWith<UserSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSummaryModelCopyWith<$Res> {
  factory $UserSummaryModelCopyWith(
          UserSummaryModel value, $Res Function(UserSummaryModel) then) =
      _$UserSummaryModelCopyWithImpl<$Res, UserSummaryModel>;
  @useResult
  $Res call({String id, String fullName, int loanLimit, String kycStatus});
}

/// @nodoc
class _$UserSummaryModelCopyWithImpl<$Res, $Val extends UserSummaryModel>
    implements $UserSummaryModelCopyWith<$Res> {
  _$UserSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? loanLimit = null,
    Object? kycStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      loanLimit: null == loanLimit
          ? _value.loanLimit
          : loanLimit // ignore: cast_nullable_to_non_nullable
              as int,
      kycStatus: null == kycStatus
          ? _value.kycStatus
          : kycStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSummaryModelImplCopyWith<$Res>
    implements $UserSummaryModelCopyWith<$Res> {
  factory _$$UserSummaryModelImplCopyWith(_$UserSummaryModelImpl value,
          $Res Function(_$UserSummaryModelImpl) then) =
      __$$UserSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fullName, int loanLimit, String kycStatus});
}

/// @nodoc
class __$$UserSummaryModelImplCopyWithImpl<$Res>
    extends _$UserSummaryModelCopyWithImpl<$Res, _$UserSummaryModelImpl>
    implements _$$UserSummaryModelImplCopyWith<$Res> {
  __$$UserSummaryModelImplCopyWithImpl(_$UserSummaryModelImpl _value,
      $Res Function(_$UserSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? loanLimit = null,
    Object? kycStatus = null,
  }) {
    return _then(_$UserSummaryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      loanLimit: null == loanLimit
          ? _value.loanLimit
          : loanLimit // ignore: cast_nullable_to_non_nullable
              as int,
      kycStatus: null == kycStatus
          ? _value.kycStatus
          : kycStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSummaryModelImpl implements _UserSummaryModel {
  const _$UserSummaryModelImpl(
      {required this.id,
      required this.fullName,
      required this.loanLimit,
      required this.kycStatus});

  factory _$UserSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final int loanLimit;
  @override
  final String kycStatus;

  @override
  String toString() {
    return 'UserSummaryModel(id: $id, fullName: $fullName, loanLimit: $loanLimit, kycStatus: $kycStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.loanLimit, loanLimit) ||
                other.loanLimit == loanLimit) &&
            (identical(other.kycStatus, kycStatus) ||
                other.kycStatus == kycStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fullName, loanLimit, kycStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSummaryModelImplCopyWith<_$UserSummaryModelImpl> get copyWith =>
      __$$UserSummaryModelImplCopyWithImpl<_$UserSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _UserSummaryModel implements UserSummaryModel {
  const factory _UserSummaryModel(
      {required final String id,
      required final String fullName,
      required final int loanLimit,
      required final String kycStatus}) = _$UserSummaryModelImpl;

  factory _UserSummaryModel.fromJson(Map<String, dynamic> json) =
      _$UserSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  int get loanLimit;
  @override
  String get kycStatus;
  @override
  @JsonKey(ignore: true)
  _$$UserSummaryModelImplCopyWith<_$UserSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoanSummaryModel _$LoanSummaryModelFromJson(Map<String, dynamic> json) {
  return _LoanSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$LoanSummaryModel {
  String get id => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  int get outstandingBalance => throw _privateConstructorUsedError;
  DateTime? get disbursedAt => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanSummaryModelCopyWith<LoanSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanSummaryModelCopyWith<$Res> {
  factory $LoanSummaryModelCopyWith(
          LoanSummaryModel value, $Res Function(LoanSummaryModel) then) =
      _$LoanSummaryModelCopyWithImpl<$Res, LoanSummaryModel>;
  @useResult
  $Res call(
      {String id,
      int amount,
      String status,
      DateTime dueDate,
      int outstandingBalance,
      DateTime? disbursedAt,
      DateTime? paidAt});
}

/// @nodoc
class _$LoanSummaryModelCopyWithImpl<$Res, $Val extends LoanSummaryModel>
    implements $LoanSummaryModelCopyWith<$Res> {
  _$LoanSummaryModelCopyWithImpl(this._value, this._then);

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
    Object? outstandingBalance = null,
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
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$LoanSummaryModelImplCopyWith<$Res>
    implements $LoanSummaryModelCopyWith<$Res> {
  factory _$$LoanSummaryModelImplCopyWith(_$LoanSummaryModelImpl value,
          $Res Function(_$LoanSummaryModelImpl) then) =
      __$$LoanSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int amount,
      String status,
      DateTime dueDate,
      int outstandingBalance,
      DateTime? disbursedAt,
      DateTime? paidAt});
}

/// @nodoc
class __$$LoanSummaryModelImplCopyWithImpl<$Res>
    extends _$LoanSummaryModelCopyWithImpl<$Res, _$LoanSummaryModelImpl>
    implements _$$LoanSummaryModelImplCopyWith<$Res> {
  __$$LoanSummaryModelImplCopyWithImpl(_$LoanSummaryModelImpl _value,
      $Res Function(_$LoanSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? status = null,
    Object? dueDate = null,
    Object? outstandingBalance = null,
    Object? disbursedAt = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_$LoanSummaryModelImpl(
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
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$LoanSummaryModelImpl implements _LoanSummaryModel {
  const _$LoanSummaryModelImpl(
      {required this.id,
      required this.amount,
      required this.status,
      required this.dueDate,
      required this.outstandingBalance,
      this.disbursedAt,
      this.paidAt});

  factory _$LoanSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final int amount;
  @override
  final String status;
  @override
  final DateTime dueDate;
  @override
  final int outstandingBalance;
  @override
  final DateTime? disbursedAt;
  @override
  final DateTime? paidAt;

  @override
  String toString() {
    return 'LoanSummaryModel(id: $id, amount: $amount, status: $status, dueDate: $dueDate, outstandingBalance: $outstandingBalance, disbursedAt: $disbursedAt, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.outstandingBalance, outstandingBalance) ||
                other.outstandingBalance == outstandingBalance) &&
            (identical(other.disbursedAt, disbursedAt) ||
                other.disbursedAt == disbursedAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, amount, status, dueDate,
      outstandingBalance, disbursedAt, paidAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanSummaryModelImplCopyWith<_$LoanSummaryModelImpl> get copyWith =>
      __$$LoanSummaryModelImplCopyWithImpl<_$LoanSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _LoanSummaryModel implements LoanSummaryModel {
  const factory _LoanSummaryModel(
      {required final String id,
      required final int amount,
      required final String status,
      required final DateTime dueDate,
      required final int outstandingBalance,
      final DateTime? disbursedAt,
      final DateTime? paidAt}) = _$LoanSummaryModelImpl;

  factory _LoanSummaryModel.fromJson(Map<String, dynamic> json) =
      _$LoanSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  int get amount;
  @override
  String get status;
  @override
  DateTime get dueDate;
  @override
  int get outstandingBalance;
  @override
  DateTime? get disbursedAt;
  @override
  DateTime? get paidAt;
  @override
  @JsonKey(ignore: true)
  _$$LoanSummaryModelImplCopyWith<_$LoanSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
