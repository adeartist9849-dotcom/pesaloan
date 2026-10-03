import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategory(
              context,
              'Getting Started',
              [
                _FaqItem(
                  question: 'How do I create an account?',
                  answer:
                      'Download the app, tap "Register", enter your phone number, verify with OTP, fill in your details, create a PIN, and complete KYC verification.',
                ),
                _FaqItem(
                  question: 'What do I need to register?',
                  answer:
                      'You need a valid Kenyan phone number, national ID, date of birth, and an active M-Pesa or Airtel Money account.',
                ),
                _FaqItem(
                  question: 'What is KYC and why is it required?',
                  answer:
                      'KYC (Know Your Customer) is a regulatory requirement by the Central Bank of Kenya. It involves verifying your identity using your national ID and a selfie. This helps prevent fraud and money laundering.',
                ),
              ],
            ),
            _buildCategory(
              context,
              'Loans',
              [
                _FaqItem(
                  question: 'How much can I borrow?',
                  answer:
                      'You can borrow between KES 500 and KES 50,000. Your exact limit depends on your credit history and KYC status.',
                ),
                _FaqItem(
                  question: 'What is the interest rate?',
                  answer:
                      'The interest rate is 15% per annum, pro-rated for your loan term. For example, a 30-day loan of KES 10,000 would have interest of approximately KES 123.',
                ),
                _FaqItem(
                  question: 'What is the processing fee?',
                  answer:
                      'The processing fee is 5% of the loan amount. This is a one-time fee charged at disbursement.',
                ),
                _FaqItem(
                  question: 'How long do I have to repay?',
                  answer:
                      'Loan terms range from 7 to 90 days. You choose your preferred term when applying for a loan.',
                ),
                _FaqItem(
                  question: 'Can I repay early?',
                  answer:
                      'Yes! You can repay your loan at any time before the due date with no prepayment penalty. You will only pay interest for the days you borrowed.',
                ),
                _FaqItem(
                  question: 'What happens if I repay late?',
                  answer:
                      'Late payments attract a penalty of 1% per day on the outstanding amount. Additionally, late payments are reported to Credit Reference Bureaus, which may affect your credit score.',
                ),
              ],
            ),
            _buildCategory(
              context,
              'Repayment',
              [
                _FaqItem(
                  question: 'How do I repay my loan?',
                  answer:
                      'Go to your loan details and tap "Make Payment". You will be prompted to enter your M-Pesa PIN to complete the payment via STK Push.',
                ),
                _FaqItem(
                  question: 'What payment methods are accepted?',
                  answer:
                      'We accept M-Pesa STK Push and Airtel Money. More payment options will be added soon.',
                ),
                _FaqItem(
                  question: 'How do I confirm my payment?',
                  answer:
                      'After making a payment, you will receive an SMS confirmation. The payment will also be reflected in your loan details within a few minutes.',
                ),
              ],
            ),
            _buildCategory(
              context,
              'Account & Security',
              [
                _FaqItem(
                  question: 'How do I change my PIN?',
                  answer:
                      'Go to Profile > Settings > Change PIN. You will need to enter your current PIN and then set a new one.',
                ),
                _FaqItem(
                  question: 'What if I forget my PIN?',
                  answer:
                      'Tap "Forgot PIN?" on the login screen. You will need to verify your identity with an OTP sent to your registered phone number.',
                ),
                _FaqItem(
                  question: 'How is my data protected?',
                  answer:
                      'We use bank-grade encryption, secure authentication, and comply with the Kenya Data Protection Act, 2019. See our Privacy Policy for details.',
                ),
                _FaqItem(
                  question: 'Can I use biometric login?',
                  answer:
                      'Yes, you can enable fingerprint or face ID login in Settings > Security > Biometric Login.',
                ),
              ],
            ),
            _buildCategory(
              context,
              'Credit & CRB',
              [
                _FaqItem(
                  question: 'How do I build my credit score?',
                  answer:
                      'Repay your loans on time, avoid defaults, and keep your borrowing within your means. Positive repayment history is reported to CRBs.',
                ),
                _FaqItem(
                  question: 'How do I check my credit report?',
                  answer:
                      'You can get your credit report from TransUnion Africa (dial *434#), CreditInfo Kenya, or Metropol CRB. See our CRB Disclosure for details.',
                ),
                _FaqItem(
                  question: 'What happens if I default?',
                  answer:
                      'Defaulted loans are reported to CRBs, which negatively affects your credit score. You may also face legal action to recover the debt.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Contact our support team and we will be happy to assist you.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Navigate to support screen
                          },
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Contact Support'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, List<_FaqItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: items
                .map((item) => ExpansionTile(
                      title: Text(
                        item.question,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            item.answer,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}
