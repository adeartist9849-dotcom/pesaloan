import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

@freezed
class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) = _AuthTokensModel;
  
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) => _$AuthTokensModelFromJson(json);
}