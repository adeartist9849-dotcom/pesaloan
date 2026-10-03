import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Acceptance of Terms',
              'By downloading, installing, or using the PesaLoan mobile application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, do not use the application.',
            ),
            _buildSection(
              '2. About PesaLoan',
              'PesaLoan is a digital lending platform operated by PesaLoan Limited, a company incorporated in Kenya. We provide short-term loans to eligible customers through our mobile application.',
            ),
            _buildSection(
              '3. Eligibility',
              'To be eligible for a PesaLoan loan, you must:\n'
                  '• Be at least 18 years of age\n'
                  '• Be a Kenyan resident\n'
                  '• Have a valid Kenyan national ID\n'
                  '• Have an active M-Pesa or Airtel Money account\n'
                  '• Have a valid phone number registered in your name\n'
                  '• Complete KYC verification',
            ),
            _buildSection(
              '4. Loan Terms',
              '• Loan amounts range from KES 500 to KES 50,000\n'
                  '• Loan terms range from 7 to 90 days\n'
                  '• Interest rate: 15% per annum (pro-rated for the loan term)\n'
                  '• Processing fee: 5% of the loan amount\n'
                  '• Late payment penalty: 1% per day on the outstanding amount\n'
                  '• Early repayment is allowed with no prepayment penalty',
            ),
            _buildSection(
              '5. Total Cost of Credit',
              'The total cost of credit includes:\n'
                  '• Principal amount borrowed\n'
                  '• Interest charges (15% per annum)\n'
                  '• Processing fee (5% of principal)\n'
                  '• Any applicable late payment penalties\n\n'
                  'The Annual Percentage Rate (APR) is approximately 32.25% for a 30-day loan. The exact APR will be displayed in your loan offer before acceptance.',
            ),
            _buildSection(
              '6. Repayment',
              '• Repayments are made via M-Pesa STK Push or Airtel Money\n'
                  '• The repayment amount and due date are shown in your loan offer\n'
                  '• You must ensure sufficient funds in your mobile money account on the due date\n'
                  '• Late payments attract a penalty of 1% per day on the outstanding amount\n'
                  '• Default may affect your credit score and future loan eligibility',
            ),
            _buildSection(
              '7. Cooling-Off Period',
              'You have a cooling-off period of 24 hours from the time of loan disbursement. During this period, you may choose to repay the loan in full without incurring any interest or penalties. To exercise this right, contact our support team immediately.',
            ),
            _buildSection(
              '8. Credit Reference Bureau (CRB) Reporting',
              'In accordance with the Central Bank of Kenya (Credit Reference Bureau) Regulations, 2020:\n'
                  '• We will report your loan information to licensed Credit Reference Bureaus\n'
                  '• Both positive and negative credit information will be reported\n'
                  '• Defaulted loans will be reported to the CRB\n'
                  '• You have the right to access your credit report from any licensed CRB\n'
                  '• You may dispute inaccurate information through the CRB dispute resolution process',
            ),
            _buildSection(
              '9. Data Protection',
              '• We collect and process your personal data in accordance with the Data Protection Act, 2019\n'
                  '• Your data is used for loan processing, KYC verification, and credit assessment\n'
                  '• We will never sell your personal data to third parties\n'
                  '• You have the right to access, correct, and delete your personal data\n'
                  '• See our Privacy Policy for full details on data handling',
            ),
            _buildSection(
              '10. Anti-Money Laundering (AML)',
              'In compliance with the Proceeds of Crime and Anti-Money Laundering Act, 2009:\n'
                  '• We conduct customer due diligence before loan disbursement\n'
                  '• We monitor transactions for suspicious activity\n'
                  '• We report suspicious transactions to the Financial Reporting Centre\n'
                  '• You must provide accurate information during registration',
            ),
            _buildSection(
              '11. Limitation of Liability',
              'PesaLoan shall not be liable for:\n'
                  '• Losses arising from your failure to repay on time\n'
                  '• Service interruptions due to network or system failures\n'
                  '• Unauthorized access to your account due to your negligence\n'
                  '• Third-party service provider failures (e.g., M-Pesa, Airtel Money)',
            ),
            _buildSection(
              '12. Amendments',
              'We reserve the right to amend these Terms and Conditions at any time. Material changes will be communicated through the app, SMS, or email at least 14 days before taking effect. Continued use of the app after amendments constitutes acceptance.',
            ),
            _buildSection(
              '13. Governing Law',
              'These Terms and Conditions are governed by the laws of the Republic of Kenya. Any disputes shall be subject to the exclusive jurisdiction of the courts of Kenya.',
            ),
            _buildSection(
              '14. Contact Information',
              'For questions about these Terms and Conditions:\n'
                  '• Email: legal@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n'
                  '• Address: PesaLoan Limited, Nairobi, Kenya',
            ),
            const SizedBox(height: 24),
            Text(
              'Last updated: January 2025',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
