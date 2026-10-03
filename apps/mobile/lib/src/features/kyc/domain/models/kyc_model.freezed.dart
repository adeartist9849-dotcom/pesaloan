// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kyc_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KycModel _$KycModelFromJson(Map<String, dynamic> json) {
  return _KycModel.fromJson(json);
}

/// @nodoc
mixin _$KycModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String get providerReference => throw _privateConstructorUsedError;
  Map<String, dynamic> get verificationData =>
      throw _privateConstructorUsedError;
  String? get verifiedAt => throw _privateConstructorUsedError;
  String? get rejectedAt => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get expiresAt => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KycModelCopyWith<KycModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KycModelCopyWith<$Res> {
  factory $KycModelCopyWith(KycModel value, $Res Function(KycModel) then) =
      _$KycModelCopyWithImpl<$Res, KycModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String status,
      String provider,
      String providerReference,
      Map<String, dynamic> verificationData,
      String? verifiedAt,
      String? rejectedAt,
      String? rejectionReason,
      String? expiresAt,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$KycModelCopyWithImpl<$Res, $Val extends KycModel>
    implements $KycModelCopyWith<$Res> {
  _$KycModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? status = null,
    Object? provider = null,
    Object? providerReference = null,
    Object? verificationData = null,
    Object? verifiedAt = freezed,
    Object? rejectedAt = freezed,
    Object? rejectionReason = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      providerReference: null == providerReference
          ? _value.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String,
      verificationData: null == verificationData
          ? _value.verificationData
          : verificationData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KycModelImplCopyWith<$Res>
    implements $KycModelCopyWith<$Res> {
  factory _$$KycModelImplCopyWith(
          _$KycModelImpl value, $Res Function(_$KycModelImpl) then) =
      __$$KycModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String status,
      String provider,
      String providerReference,
      Map<String, dynamic> verificationData,
      String? verifiedAt,
      String? rejectedAt,
      String? rejectionReason,
      String? expiresAt,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$KycModelImplCopyWithImpl<$Res>
    extends _$KycModelCopyWithImpl<$Res, _$KycModelImpl>
    implements _$$KycModelImplCopyWith<$Res> {
  __$$KycModelImplCopyWithImpl(
      _$KycModelImpl _value, $Res Function(_$KycModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? status = null,
    Object? provider = null,
    Object? providerReference = null,
    Object? verificationData = null,
    Object? verifiedAt = freezed,
    Object? rejectedAt = freezed,
    Object? rejectionReason = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$KycModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      providerReference: null == providerReference
          ? _value.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String,
      verificationData: null == verificationData
          ? _value._verificationData
          : verificationData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
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
class _$KycModelImpl implements _KycModel {
  const _$KycModelImpl(
      {required this.id,
      required this.userId,
      required this.status,
      required this.provider,
      required this.providerReference,
      required final Map<String, dynamic> verificationData,
      this.verifiedAt,
      this.rejectedAt,
      this.rejectionReason,
      this.expiresAt,
      required this.createdAt,
      required this.updatedAt})
      : _verificationData = verificationData;

  factory _$KycModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KycModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String status;
  @override
  final String provider;
  @override
  final String providerReference;
  final Map<String, dynamic> _verificationData;
  @override
  Map<String, dynamic> get verificationData {
    if (_verificationData is EqualUnmodifiableMapView) return _verificationData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_verificationData);
  }

  @override
  final String? verifiedAt;
  @override
  final String? rejectedAt;
  @override
  final String? rejectionReason;
  @override
  final String? expiresAt;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'KycModel(id: $id, userId: $userId, status: $status, provider: $provider, providerReference: $providerReference, verificationData: $verificationData, verifiedAt: $verifiedAt, rejectedAt: $rejectedAt, rejectionReason: $rejectionReason, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KycModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerReference, providerReference) ||
                other.providerReference == providerReference) &&
            const DeepCollectionEquality()
                .equals(other._verificationData, _verificationData) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
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
      userId,
      status,
      provider,
      providerReference,
      const DeepCollectionEquality().hash(_verificationData),
      verifiedAt,
      rejectedAt,
      rejectionReason,
      expiresAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KycModelImplCopyWith<_$KycModelImpl> get copyWith =>
      __$$KycModelImplCopyWithImpl<_$KycModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KycModelImplToJson(
      this,
    );
  }
}

abstract class _KycModel implements KycModel {
  const factory _KycModel(
      {required final String id,
      required final String userId,
      required final String status,
      required final String provider,
      required final String providerReference,
      required final Map<String, dynamic> verificationData,
      final String? verifiedAt,
      final String? rejectedAt,
      final String? rejectionReason,
      final String? expiresAt,
      required final String createdAt,
      required final String updatedAt}) = _$KycModelImpl;

  factory _KycModel.fromJson(Map<String, dynamic> json) =
      _$KycModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get status;
  @override
  String get provider;
  @override
  String get providerReference;
  @override
  Map<String, dynamic> get verificationData;
  @override
  String? get verifiedAt;
  @override
  String? get rejectedAt;
  @override
  String? get rejectionReason;
  @override
  String? get expiresAt;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$KycModelImplCopyWith<_$KycModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
