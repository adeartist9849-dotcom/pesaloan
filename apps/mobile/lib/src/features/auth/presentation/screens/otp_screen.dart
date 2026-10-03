import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isRegistration;
  
  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.isRegistration,
  });
  
  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _resendCountdown = 0;
  
  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }
  
  void _startResendCountdown() {
    _resendCountdown = AppConstants.otpExpiryMinutes * 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _resendCountdown--);
        return _resendCountdown > 0;
      }
      return false;
    });
  }
  
  Future<void> _verifyOtp() async {
    if (_otpController.text.length != AppConstants.otpLength) return;
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authStateProvider.notifier).verifyOtp(
        phoneNumber: widget.phoneNumber,
        code: _otpController.text,
      );
      
      if (mounted) {
        if (widget.isRegistration) {
          context.go(AppConstants.routeCreatePin);
        } else {
          context.go(AppConstants.routeHome);
        }
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
  
  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authStateProvider.notifier).requestOtp(
        phoneNumber: widget.phoneNumber,
        isRegistration: widget.isRegistration,
      );
      
      _otpController.clear();
      _startResendCountdown();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
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
  
  String _formatPhoneNumber(String phone) {
    if (phone.startsWith('254')) {
      return '+254 ${phone.substring(3, 6)} ${phone.substring(6, 9)} ${phone.substring(9)}';
    }
    return phone;
  }
  
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify Your Number',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a 6-digit code to',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _formatPhoneNumber(widget.phoneNumber),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: AppConstants.otpLength,
                  controller: _otpController,
                  onChanged: (value) {
                    if (value.length == AppConstants.otpLength) {
                      _verifyOtp();
                    }
                  },
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 56,
                    fieldWidth: 48,
                    activeFillColor: AppTheme.primaryGreen.withOpacity(0.1),
                    inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    selectedFillColor: AppTheme.primaryGreen.withOpacity(0.2),
                    activeColor: AppTheme.primaryGreen,
                    inactiveColor: Theme.of(context).colorScheme.outline,
                    selectedColor: AppTheme.primaryGreen,
                    borderWidth: 1.5,
                  ),
                  enableActiveFill: true,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 200),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _resendCountdown > 0
                    ? 'Resend code in ${(_resendCountdown ~/ 60).toString().padLeft(2, '0')}:${(_resendCountdown % 60).toString().padLeft(2, '0')}'
                    : 'Didn\'t receive the code?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (_resendCountdown == 0)
                TextButton(
                  onPressed: _isLoading ? null : _resendOtp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Resend Code'),
                ),
              const Spacer(),
              Text(
                'This code expires in ${AppConstants.otpExpiryMinutes} minutes. Never share it with anyone.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}