import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phoneNumber,
    required String fullName,
    required String dateOfBirth,
    required String nationalId,
    String? email,
    required String status,
    required String kycStatus,
    required int loanLimit,
    String? lastLoginAt,
    required int failedLoginAttempts,
    String? lockedUntil,
    required String createdAt,
    required String updatedAt,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromJsonString(String jsonString) =>
      UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}

extension UserModelSerialization on UserModel {
  String toJsonString() => jsonEncode(toJson());
}