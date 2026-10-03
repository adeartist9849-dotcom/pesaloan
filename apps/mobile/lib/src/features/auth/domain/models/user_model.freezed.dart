// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get dateOfBirth => throw _privateConstructorUsedError;
  String get nationalId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get kycStatus => throw _privateConstructorUsedError;
  int get loanLimit => throw _privateConstructorUsedError;
  String? get lastLoginAt => throw _privateConstructorUsedError;
  int get failedLoginAttempts => throw _privateConstructorUsedError;
  String? get lockedUntil => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String phoneNumber,
      String fullName,
      String dateOfBirth,
      String nationalId,
      String? email,
      String status,
      String kycStatus,
      int loanLimit,
      String? lastLoginAt,
      int failedLoginAttempts,
      String? lockedUntil,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = null,
    Object? fullName = null,
    Object? dateOfBirth = null,
    Object? nationalId = null,
    Object? email = freezed,
    Object? status = null,
    Object? kycStatus = null,
    Object? loanLimit = null,
    Object? lastLoginAt = freezed,
    Object? failedLoginAttempts = null,
    Object? lockedUntil = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String,
      nationalId: null == nationalId
          ? _value.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      kycStatus: null == kycStatus
          ? _value.kycStatus
          : kycStatus // ignore: cast_nullable_to_non_nullable
              as String,
      loanLimit: null == loanLimit
          ? _value.loanLimit
          : loanLimit // ignore: cast_nullable_to_non_nullable
              as int,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as String?,
      failedLoginAttempts: null == failedLoginAttempts
          ? _value.failedLoginAttempts
          : failedLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      lockedUntil: freezed == lockedUntil
          ? _value.lockedUntil
          : lockedUntil // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String phoneNumber,
      String fullName,
      String dateOfBirth,
      String nationalId,
      String? email,
      String status,
      String kycStatus,
      int loanLimit,
      String? lastLoginAt,
      int failedLoginAttempts,
      String? lockedUntil,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = null,
    Object? fullName = null,
    Object? dateOfBirth = null,
    Object? nationalId = null,
    Object? email = freezed,
    Object? status = null,
    Object? kycStatus = null,
    Object? loanLimit = null,
    Object? lastLoginAt = freezed,
    Object? failedLoginAttempts = null,
    Object? lockedUntil = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String,
      nationalId: null == nationalId
          ? _value.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      kycStatus: null == kycStatus
          ? _value.kycStatus
          : kycStatus // ignore: cast_nullable_to_non_nullable
              as String,
      loanLimit: null == loanLimit
          ? _value.loanLimit
          : loanLimit // ignore: cast_nullable_to_non_nullable
              as int,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as String?,
      failedLoginAttempts: null == failedLoginAttempts
          ? _value.failedLoginAttempts
          : failedLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      lockedUntil: freezed == lockedUntil
          ? _value.lockedUntil
          : lockedUntil // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.phoneNumber,
      required this.fullName,
      required this.dateOfBirth,
      required this.nationalId,
      this.email,
      required this.status,
      required this.kycStatus,
      required this.loanLimit,
      this.lastLoginAt,
      required this.failedLoginAttempts,
      this.lockedUntil,
      required this.createdAt,
      required this.updatedAt});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String phoneNumber;
  @override
  final String fullName;
  @override
  final String dateOfBirth;
  @override
  final String nationalId;
  @override
  final String? email;
  @override
  final String status;
  @override
  final String kycStatus;
  @override
  final int loanLimit;
  @override
  final String? lastLoginAt;
  @override
  final int failedLoginAttempts;
  @override
  final String? lockedUntil;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, fullName: $fullName, dateOfBirth: $dateOfBirth, nationalId: $nationalId, email: $email, status: $status, kycStatus: $kycStatus, loanLimit: $loanLimit, lastLoginAt: $lastLoginAt, failedLoginAttempts: $failedLoginAttempts, lockedUntil: $lockedUntil, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.nationalId, nationalId) ||
                other.nationalId == nationalId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.kycStatus, kycStatus) ||
                other.kycStatus == kycStatus) &&
            (identical(other.loanLimit, loanLimit) ||
                other.loanLimit == loanLimit) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.failedLoginAttempts, failedLoginAttempts) ||
                other.failedLoginAttempts == failedLoginAttempts) &&
            (identical(other.lockedUntil, lockedUntil) ||
                other.lockedUntil == lockedUntil) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      phoneNumber,
      fullName,
      dateOfBirth,
      nationalId,
      email,
      status,
      kycStatus,
      loanLimit,
      lastLoginAt,
      failedLoginAttempts,
      lockedUntil,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String phoneNumber,
      required final String fullName,
      required final String dateOfBirth,
      required final String nationalId,
      final String? email,
      required final String status,
      required final String kycStatus,
      required final int loanLimit,
      final String? lastLoginAt,
      required final int failedLoginAttempts,
      final String? lockedUntil,
      required final String createdAt,
      required final String updatedAt}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get phoneNumber;
  @override
  String get fullName;
  @override
  String get dateOfBirth;
  @override
  String get nationalId;
  @override
  String? get email;
  @override
  String get status;
  @override
  String get kycStatus;
  @override
  int get loanLimit;
  @override
  String? get lastLoginAt;
  @override
  int get failedLoginAttempts;
  @override
  String? get lockedUntil;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
