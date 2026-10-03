import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = FormGroup({
    'phoneNumber': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(AppConstants.phoneRegex),
    ]),
    'fullName': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(2),
      Validators.maxLength(100),
      Validators.pattern(AppConstants.nameRegex),
    ]),
    'dateOfBirth': FormControl<String>(validators: [
      Validators.required,
    ]),
    'nationalId': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(AppConstants.nationalIdRegex),
    ]),
    'email': FormControl<String>(validators: [
      Validators.email,
    ]),
    'pin': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(AppConstants.minPinLength),
      Validators.maxLength(AppConstants.maxPinLength),
      Validators.pattern(AppConstants.pinRegex),
    ]),
    'confirmPin': FormControl<String>(validators: [
      Validators.required,
    ]),
    'consentGiven': FormControl<bool>(validators: [
      Validators.requiredTrue,
    ]),
  });
  
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _isLoading = false;
  DateTime? _selectedDate;
  
  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    
    if (date != null) {
      _selectedDate = date;
      _form.control('dateOfBirth').value = date.toIso8601String().split('T').first;
    }
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
      await ref.read(authStateProvider.notifier).register(
        phoneNumber: _form.control('phoneNumber').value,
        fullName: _form.control('fullName').value,
        dateOfBirth: _form.control('dateOfBirth').value,
        nationalId: _form.control('nationalId').value,
        email: _form.control('email').value,
        pin: _form.control('pin').value,
        consentGiven: _form.control('consentGiven').value,
        consentVersion: AppConstants.termsVersion,
      );
      
      if (mounted) {
        context.go(
          '${AppConstants.routeOtp}?phone=${_form.control('phoneNumber').value}&type=register',
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                'assets/images/pesaloan-logo.svg',
                width: 200,
                height: 60,
              ),
              const SizedBox(height: 24),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Join PesaLoan and access instant credit',
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
                      formControlName: 'fullName',
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'John Doe',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Full name is required',
                        ValidationMessage.minLength: (_) => 'Name must be at least 2 characters',
                        ValidationMessage.pattern: (_) => 'Name can only contain letters, spaces, hyphens and apostrophes',
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'dateOfBirth',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select date',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      onTap: (_) => _selectDate(),
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Date of birth is required',
                      },
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'email',
                      decoration: InputDecoration(
                        labelText: 'Email (Optional)',
                        hintText: 'john@example.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validationMessages: {
                        ValidationMessage.email: (_) => 'Enter a valid email address',
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'pin',
                      decoration: InputDecoration(
                        labelText: 'Create PIN',
                        hintText: '4-6 digits',
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
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'confirmPin',
                      decoration: InputDecoration(
                        labelText: 'Confirm PIN',
                        hintText: 'Re-enter PIN',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPin ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPin = !_obscureConfirmPin),
                        ),
                      ),
                      obscureText: _obscureConfirmPin,
                      keyboardType: TextInputType.number,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please confirm your PIN',
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return Column(
                          children: [
                            CheckboxListTile(
                              title: const Text(
                                'I agree to the Terms of Service and Privacy Policy',
                                style: TextStyle(fontSize: 14),
                              ),
                              value: form.control('consentGiven').value ?? false,
                              onChanged: (value) => form.control('consentGiven').value = value ?? false,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => context.push(AppConstants.routeTerms),
                                    child: const Text(
                                      'Terms of Service',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryGreen,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ' • ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  InkWell(
                                    onTap: () => context.push(AppConstants.routePrivacyPolicy),
                                    child: const Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryGreen,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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
                          : const Text('Create Account'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppConstants.routeLogin),
                    child: const Text('Sign In'),
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
