import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});
  
  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final _form = FormGroup({
    'currentPin': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(AppConstants.minPinLength),
      Validators.maxLength(AppConstants.maxPinLength),
      Validators.pattern(AppConstants.pinRegex),
    ]),
    'newPin': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(AppConstants.minPinLength),
      Validators.maxLength(AppConstants.maxPinLength),
      Validators.pattern(AppConstants.pinRegex),
    ]),
    'confirmPin': FormControl<String>(validators: [
      Validators.required,
    ]),
  });
  
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
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
    
    if (_form.control('newPin').value != _form.control('confirmPin').value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New PINs do not match'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }
    
    if (_form.control('currentPin').value == _form.control('newPin').value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New PIN must be different from current PIN'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authStateProvider.notifier).changePin(
        currentPin: _form.control('currentPin').value,
        newPin: _form.control('newPin').value,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN changed successfully'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        context.pop();
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
      appBar: AppBar(title: const Text('Change PIN')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Icon(
              Icons.lock_reset_outlined,
              size: 80,
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'Change Your PIN',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your current PIN and set a new one',
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
                    formControlName: 'currentPin',
                    decoration: InputDecoration(
                      labelText: 'Current PIN',
                      hintText: 'Enter current PIN',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                    ),
                    obscureText: _obscureCurrent,
                    keyboardType: TextInputType.number,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Current PIN is required',
                      ValidationMessage.minLength: (_) => 'PIN must be at least ${AppConstants.minPinLength} digits',
                      ValidationMessage.maxLength: (_) => 'PIN must be at most ${AppConstants.maxPinLength} digits',
                      ValidationMessage.pattern: (_) => 'PIN must be numbers only',
                    },
                  ),
                  const SizedBox(height: 16),
                  ReactiveTextField<String>(
                    formControlName: 'newPin',
                    decoration: InputDecoration(
                      labelText: 'New PIN',
                      hintText: 'Enter new PIN',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    obscureText: _obscureNew,
                    keyboardType: TextInputType.number,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'New PIN is required',
                      ValidationMessage.minLength: (_) => 'PIN must be at least ${AppConstants.minPinLength} digits',
                      ValidationMessage.maxLength: (_) => 'PIN must be at most ${AppConstants.maxPinLength} digits',
                      ValidationMessage.pattern: (_) => 'PIN must be numbers only',
                    },
                  ),
                  const SizedBox(height: 16),
                  ReactiveTextField<String>(
                    formControlName: 'confirmPin',
                    decoration: InputDecoration(
                      labelText: 'Confirm New PIN',
                      hintText: 'Re-enter new PIN',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    obscureText: _obscureConfirm,
                    keyboardType: TextInputType.number,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Please confirm your new PIN',
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Change PIN'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your PIN should be 4-6 digits. Don\'t use easily guessable numbers like birthdays.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}