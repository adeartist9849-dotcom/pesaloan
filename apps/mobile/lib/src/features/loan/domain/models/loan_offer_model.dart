import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_offer_model.freezed.dart';
part 'loan_offer_model.g.dart';

@freezed
class LoanOfferModel with _$LoanOfferModel {
  const factory LoanOfferModel({
    required String id,
    required int amount,
    required int termDays,
    required int interest,
    required int fees,
    required int totalPayable,
    required DateTime dueDate,
    required String agreementVersion,
    required String agreementUrl,
    required String expiresAt,
  }) = _LoanOfferModel;
  
  factory LoanOfferModel.fromJson(Map<String, dynamic> json) => _$LoanOfferModelFromJson(json);
}