import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_detail_model.freezed.dart';
part 'loan_detail_model.g.dart';

@freezed
class LoanDetailModel with _$LoanDetailModel {
  const factory LoanDetailModel({
    required String id,
    required String userId,
    required String applicationId,
    required int principal,
    required int interest,
    required int fees,
    required int totalPayable,
    required int termDays,
    required int disbursedAmount,
    required int outstandingBalance,
    required String status,
    DateTime? disbursedAt,
    required DateTime dueDate,
    DateTime? paidAt,
    required String agreementVersion,
    DateTime? agreementAcceptedAt,
    required List<TransactionModel> transactions,
    required List<RepaymentModel> repayments,
  }) = _LoanDetailModel;
  
  factory LoanDetailModel.fromJson(Map<String, dynamic> json) => _$LoanDetailModelFromJson(json);
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String loanId,
    required String userId,
    required String type,
    required int amount,
    required String status,
    required String reference,
    String? provider,
    String? providerReference,
    required String description,
    required Map<String, dynamic> metadata,
    DateTime? processedAt,
    required DateTime createdAt,
  }) = _TransactionModel;
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}

@freezed
class RepaymentModel with _$RepaymentModel {
  const factory RepaymentModel({
    required String id,
    required String loanId,
    required String userId,
    required int amount,
    required String transactionReference,
    required String provider,
    String? providerTransactionId,
    required String status,
    DateTime? paidAt,
    String? failedReason,
    required Map<String, dynamic> metadata,
    required DateTime createdAt,
  }) = _RepaymentModel;
  
  factory RepaymentModel.fromJson(Map<String, dynamic> json) => _$RepaymentModelFromJson(json);
}