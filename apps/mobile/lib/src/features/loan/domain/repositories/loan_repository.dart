import 'package:pesaloan/src/features/loan/domain/models/loan_application_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_offer_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_detail_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/repayment_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_history_model.dart';

abstract class LoanRepository {
  Future<LoanApplicationModel> applyForLoan({
    required int amount,
    required int termDays,
  });
  
  Future<LoanOfferModel> getLoanOffer(String loanId);
  
  Future<void> acceptLoan({
    required String loanId,
    required String agreementVersion,
  });
  
  Future<LoanDetailModel> getLoanDetail(String loanId);
  
  Future<RepaymentDetailModel> getRepaymentDetail(String loanId);
  
  Future<void> initiateRepayment({
    required String loanId,
    required int amount,
  });
  
  Future<List<LoanHistoryModel>> getLoanHistory({
    required int page,
    required int limit,
  });
}