import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/kyc/domain/models/kyc_model.dart';
import 'package:pesaloan/src/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:pesaloan/src/features/kyc/data/repositories/kyc_repository_impl.dart';

enum KycStatus {
  notStarted,
  inProgress,
  pendingReview,
  verified,
  rejected,
  expired,
}

class KycState {
  final KycStatus status;
  final bool isLoading;
  final String? error;
  final KycModel? kycRecord;
  final String? rejectionReason;
  
  const KycState({
    this.status = KycStatus.notStarted,
    this.isLoading = false,
    this.error,
    this.kycRecord,
    this.rejectionReason,
  });
  
  KycState copyWith({
    KycStatus? status,
    bool? isLoading,
    String? error,
    KycModel? kycRecord,
    String? rejectionReason,
  }) {
    return KycState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      kycRecord: kycRecord ?? this.kycRecord,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

class KycNotifier extends StateNotifier<KycState> {
  final KycRepository _repository;
  
  KycNotifier(this._repository) : super(const KycState()) {
    _loadKycStatus();
  }
  
  Future<void> _loadKycStatus() async {
    try {
      final record = await _repository.getKycStatus();
      if (record != null) {
        state = state.copyWith(
          status: _mapStatus(record.status),
          kycRecord: record,
        );
      }
    } catch (_) {
      // Ignore
    }
  }
  
  KycStatus _mapStatus(String status) {
    switch (status) {
      case 'NOT_STARTED':
        return KycStatus.notStarted;
      case 'IN_PROGRESS':
        return KycStatus.inProgress;
      case 'PENDING_REVIEW':
        return KycStatus.pendingReview;
      case 'VERIFIED':
        return KycStatus.verified;
      case 'REJECTED':
        return KycStatus.rejected;
      case 'EXPIRED':
        return KycStatus.expired;
      default:
        return KycStatus.notStarted;
    }
  }
  
  Future<void> submitKyc({
    required String nationalId,
    String? idFrontImage,
    String? idBackImage,
    String? selfieImage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.submitKyc(
        nationalId: nationalId,
        idFrontImage: idFrontImage,
        idBackImage: idBackImage,
        selfieImage: selfieImage,
      );
      
      state = state.copyWith(
        isLoading: false,
        status: KycStatus.pendingReview,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<void> refreshStatus() async {
    try {
      final record = await _repository.getKycStatus();
      if (record != null) {
        state = state.copyWith(
          status: _mapStatus(record.status),
          kycRecord: record,
          rejectionReason: record.rejectionReason,
        );
      }
    } catch (_) {
      // Ignore
    }
  }
  
  void reset() {
    state = const KycState();
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  return KycRepositoryImpl();
});

final kycProvider = StateNotifierProvider<KycNotifier, KycState>((ref) {
  final repository = ref.watch(kycRepositoryProvider);
  return KycNotifier(repository);
});