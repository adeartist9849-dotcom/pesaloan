import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = FormGroup({
    'phoneNumber': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(AppConstants.phoneRegex),
    ]),
    'pin': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(AppConstants.minPinLength),
      Validators.maxLength(AppConstants.maxPinLength),
      Validators.pattern(AppConstants.pinRegex),
    ]),
  });
  
  bool _obscurePin = true;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
  
  Future<void> _submit() async {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authStateProvider.notifier).login(
        phoneNumber: _form.control('phoneNumber').value,
        pin: _form.control('pin').value,
      );
      
      if (mounted) {
        context.go(AppConstants.routeHome);
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst('AppException: ', '');
        // Check if registration fee is required
        if (errorMessage.contains('REGISTRATION_FEE_REQUIRED') || 
            ref.read(authStateProvider).registrationFeeRequired) {
          context.go('${AppConstants.routeRegistrationFee}?phone=${_form.control('phoneNumber').value}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              SvgPicture.asset(
                'assets/images/pesaloan-logo.svg',
                width: 200,
                height: 60,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to your PesaLoan account',
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
                    ReactiveTextField<String>(
                      formControlName: 'phoneNumber',
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '2547XXXXXXXX',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        prefixText: '+',
                      ),
                      keyboardType: TextInputType.phone,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Phone number is required',
                        ValidationMessage.pattern: (_) => 'Enter a valid Kenyan phone number (254XXXXXXXXX)',
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'pin',
                      decoration: InputDecoration(
                        labelText: 'PIN',
                        hintText: 'Enter your 4-6 digit PIN',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePin ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePin = !_obscurePin),
                        ),
                      ),
                      obscureText: _obscurePin,
                      keyboardType: TextInputType.number,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'PIN is required',
                        ValidationMessage.minLength: (_) => 'PIN must be at least ${AppConstants.minPinLength} digits',
                        ValidationMessage.maxLength: (_) => 'PIN must be at most ${AppConstants.maxPinLength} digits',
                        ValidationMessage.pattern: (_) => 'PIN must be numbers only',
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot PIN flow
                        },
                        child: const Text('Forgot PIN?'),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                          : const Text('Sign In'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppConstants.routeRegister),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}