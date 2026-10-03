import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:pesaloan/src/features/kyc/presentation/providers/kyc_provider.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});
  
  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  final _form = FormGroup({
    'nationalId': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(AppConstants.nationalIdRegex),
    ]),
    'idFrontImage': FormControl<String>(),
    'idBackImage': FormControl<String>(),
    'selfieImage': FormControl<String>(),
  });
  
  bool _isLoading = false;
  String? _currentStep; // 'id_front', 'id_back', 'selfie'
  
  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage(String step) async {
    // TODO: Implement image picker
    setState(() => _currentStep = step);
    // For now, simulate
    if (step == 'id_front') {
      _form.control('idFrontImage').value = 'base64_image_data';
    } else if (step == 'id_back') {
      _form.control('idBackImage').value = 'base64_image_data';
    } else if (step == 'selfie') {
      _form.control('selfieImage').value = 'base64_image_data';
    }
  }
  
  Future<void> _submit() async {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(kycProvider.notifier).submitKyc(
        nationalId: _form.control('nationalId').value,
        idFrontImage: _form.control('idFrontImage').value,
        idBackImage: _form.control('idBackImage').value,
        selfieImage: _form.control('selfieImage').value,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('KYC submitted for review'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        context.go(AppConstants.routeHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('AppException: ', '')),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final kycState = ref.watch(kycProvider);
    final user = ref.watch(authStateProvider).user;
    
    if (kycState.status == KycStatus.verified) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, size: 80, color: AppTheme.successGreen),
              const SizedBox(height: 24),
              Text(
                'KYC Verified',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your identity has been verified. You can now apply for loans.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppConstants.routeHome),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (kycState.status == KycStatus.inProgress || kycState.status == KycStatus.pendingReview) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                kycState.status == KycStatus.inProgress
                    ? 'Verifying your identity...'
                    : 'Under Review',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This usually takes a few minutes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (kycState.status == KycStatus.rejected) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cancel_outlined, size: 80, color: AppTheme.errorRed),
              const SizedBox(height: 24),
              Text(
                'KYC Rejected',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kycState.rejectionReason ?? 'Your KYC submission was rejected. Please try again.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Reset to allow resubmission
                  ref.read(kycProvider.notifier).reset();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }
    
    // NOT_STARTED - Show KYC form
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Identity Verification',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Complete KYC to unlock your loan limit',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ReactiveForm(
                formGroup: _form,
                child: Column(
                  children: [
                    ReactiveTextField<String>(
                      formControlName: 'nationalId',
                      decoration: InputDecoration(
                        labelText: 'National ID Number',
                        hintText: '12345678',
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'National ID is required',
                        ValidationMessage.pattern: (_) => 'National ID must be 8 digits',
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Document Images',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      label: 'Front of ID',
                      onTap: () => _pickImage('id_front'),
                      imageData: _form.control('idFrontImage').value,
                    ),
                    const SizedBox(height: 12),
                    _buildImagePicker(
                      label: 'Back of ID',
                      onTap: () => _pickImage('id_back'),
                      imageData: _form.control('idBackImage').value,
                    ),
                    const SizedBox(height: 12),
                    _buildImagePicker(
                      label: 'Selfie (with ID)',
                      onTap: () => _pickImage('selfie'),
                      imageData: _form.control('selfieImage').value,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Submit for Verification'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'We use bank-grade encryption to protect your documents. They are only used for identity verification.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImagePicker({
    required String label,
    required VoidCallback onTap,
    String? imageData,
  }) {
    final hasImage = imageData != null && imageData.isNotEmpty;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasImage ? AppTheme.primaryGreen : Theme.of(context).colorScheme.outline,
            width: hasImage ? 2 : 1,
          ),
        ),
        child: hasImage
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      child: const Icon(Icons.image_outlined, size: 48, color: AppTheme.primaryGreen),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add $label',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}