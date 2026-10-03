import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardModel with _$DashboardModel {
  const factory DashboardModel({
    required UserSummaryModel user,
    required int availableLimit,
    LoanSummaryModel? currentLoan,
    required List<LoanSummaryModel> recentLoans,
  }) = _DashboardModel;
  
  factory DashboardModel.fromJson(Map<String, dynamic> json) => _$DashboardModelFromJson(json);
}

@freezed
class UserSummaryModel with _$UserSummaryModel {
  const factory UserSummaryModel({
    required String id,
    required String fullName,
    required int loanLimit,
    required String kycStatus,
  }) = _UserSummaryModel;
  
  factory UserSummaryModel.fromJson(Map<String, dynamic> json) => _$UserSummaryModelFromJson(json);
}

@freezed
class LoanSummaryModel with _$LoanSummaryModel {
  const factory LoanSummaryModel({
    required String id,
    required int amount,
    required String status,
    required DateTime dueDate,
    required int outstandingBalance,
    DateTime? disbursedAt,
    DateTime? paidAt,
  }) = _LoanSummaryModel;
  
  factory LoanSummaryModel.fromJson(Map<String, dynamic> json) => _$LoanSummaryModelFromJson(json);
}