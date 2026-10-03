import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_application_model.freezed.dart';
part 'loan_application_model.g.dart';

@freezed
class LoanApplicationModel with _$LoanApplicationModel {
  const factory LoanApplicationModel({
    required String id,
    required String userId,
    required int requestedAmount,
    required int requestedTermDays,
    required String status,
    int? score,
    String? decisionReason,
    required String createdAt,
    required String expiresAt,
  }) = _LoanApplicationModel;
  
  factory LoanApplicationModel.fromJson(Map<String, dynamic> json) => _$LoanApplicationModelFromJson(json);
}