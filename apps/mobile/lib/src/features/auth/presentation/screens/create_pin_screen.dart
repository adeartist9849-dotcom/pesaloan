import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});
  
  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  final _form = FormGroup({
    'pin': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(AppConstants.minPinLength),
      Validators.maxLength(AppConstants.maxPinLength),
      Validators.pattern(AppConstants.pinRegex),
    ]),
    'confirmPin': FormControl<String>(validators: [
      Validators.required,
    ]),
  });
  
  bool _isLoading = false;
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      _form.control('pin').value = _pinController.text;
    });
    _confirmPinController.addListener(() {
      _form.control('confirmPin').value = _confirmPinController.text;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _form.dispose();
    super.dispose();
  }
  
  Future<void> _submit() async {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    
    if (_form.control('pin').value != _form.control('confirmPin').value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PINs do not match'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authStateProvider.notifier).createPin(
        pin: _form.control('pin').value,
      );
      
      if (mounted) {
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.lock_outlined,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Create Your PIN',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Set a 4-6 digit PIN to secure your account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ReactiveForm(
                formGroup: _form,
                child: Column(
                  children: [
                    PinCodeTextField(
                      appContext: context,
                      length: AppConstants.maxPinLength,
                      controller: _pinController,
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
                    const SizedBox(height: 24),
                    Text(
                      'Confirm PIN',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PinCodeTextField(
                      appContext: context,
                      length: AppConstants.maxPinLength,
                      controller: _confirmPinController,
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
                      onCompleted: (value) {
                        if (_form.valid && _form.control('pin').value == value) {
                          _submit();
                        }
                      },
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
                          : const Text('Continue'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Don\'t share your PIN with anyone. PesaLoan will never ask for it.',
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
