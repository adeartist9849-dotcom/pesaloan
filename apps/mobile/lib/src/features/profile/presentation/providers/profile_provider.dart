import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:pesaloan/src/features/profile/data/repositories/profile_repository_impl.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  final String kycStatus;
  
  const ProfileState({
    this.isLoading = false,
    this.error,
    this.kycStatus = 'NOT_STARTED',
  });
  
  ProfileState copyWith({
    bool? isLoading,
    String? error,
    String? kycStatus,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  
  ProfileNotifier(this._repository) : super(const ProfileState());
  
  Future<void> loadProfile() async {
    // Profile is loaded via auth state
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});