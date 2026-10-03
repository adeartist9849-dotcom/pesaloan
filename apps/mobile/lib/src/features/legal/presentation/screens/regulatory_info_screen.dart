import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class RegulatoryInfoScreen extends ConsumerWidget {
  const RegulatoryInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regulatory Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Central Bank of Kenya (CBK) Regulation',
              'PesaLoan Limited operates as a digital credit provider in compliance with the Central Bank of Kenya (Digital Credit Providers) Regulations, 2022.\n\n'
                  '**CBK License:** PesaLoan Limited is in the process of obtaining its Digital Credit Provider License from the Central Bank of Kenya.\n\n'
                  '**Regulatory Framework:**\n'
                  '• Central Bank of Kenya Act, Cap 491\n'
                  '• Digital Credit Providers Regulations, 2022\n'
                  '• Consumer Protection Framework\n'
                  '• Credit Reference Bureau Regulations, 2020',
            ),
            _buildSection(
              'Data Protection Compliance',
              'PesaLoan Limited is registered with the Office of the Data Protection Commissioner (ODPC) in accordance with the Data Protection Act, 2019.\n\n'
                  '**ODPC Registration:** PesaLoan Limited is registered as a data controller and data processor.\n\n'
                  '**Data Protection Officer:**\n'
                  '• Email: dpo@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n\n'
                  '**Your Rights:** You have the right to access, correct, and delete your personal data. See our Privacy Policy for full details.',
            ),
            _buildSection(
              'Anti-Money Laundering (AML) Compliance',
              'PesaLoan Limited complies with the Proceeds of Crime and Anti-Money Laundering Act, 2009 and the Prevention of Terrorism Act, 2012.\n\n'
                  '**Our AML Measures:**\n'
                  '• Customer due diligence (KYC) before loan disbursement\n'
                  '• Transaction monitoring for suspicious activity\n'
                  '• Reporting to the Financial Reporting Centre (FRC)\n'
                  '• Employee training on AML/CFT compliance\n'
                  '• Record keeping for 7 years',
            ),
            _buildSection(
              'Consumer Protection',
              'PesaLoan Limited is committed to fair lending practices in line with the CBK Consumer Protection Framework:\n\n'
                  '• **Transparency:** All fees and charges are disclosed upfront\n'
                  '• **Fair treatment:** No discriminatory lending practices\n'
                  '• **Data privacy:** Your personal data is protected\n'
                  '• **Complaints handling:** We have a formal complaints process\n'
                  '• **Responsible lending:** We assess your ability to repay before lending',
            ),
            _buildSection(
              'Interest Rate & Fee Disclosure',
              'In compliance with the CBK Digital Credit Providers Regulations, 2022:\n\n'
                  '• **Interest Rate:** 15% per annum (pro-rated for the loan term)\n'
                  '• **Processing Fee:** 5% of the loan amount\n'
                  '• **Late Payment Penalty:** 1% per day on the outstanding amount\n'
                  '• **Annual Percentage Rate (APR):** Approximately 32.25% for a 30-day loan\n\n'
                  'The exact APR and total cost of credit will be displayed in your loan offer before acceptance.',
            ),
            _buildSection(
              'Complaints & Dispute Resolution',
              'If you have a complaint about our services:\n\n'
                  '**Step 1:** Contact our support team\n'
                  '• Email: support@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n\n'
                  '**Step 2:** If not resolved, escalate to our Complaints Officer\n'
                  '• Email: complaints@PesaLoan.co.ke\n\n'
                  '**Step 3:** If still unresolved, contact the CBK\n'
                  '• Email: cbk@centralbank.go.ke\n'
                  '• Website: www.centralbank.go.ke\n\n'
                  'We aim to resolve all complaints within 14 days.',
            ),
            _buildSection(
              'Regulatory Bodies',
              '**Central Bank of Kenya (CBK):**\n'
                  '• Website: www.centralbank.go.ke\n'
                  '• Phone: +254 20 286 0000\n\n'
                  '**Office of the Data Protection Commissioner (ODPC):**\n'
                  '• Website: www.odpc.go.ke\n'
                  '• Email: complaints@odpc.go.ke\n\n'
                  '**Financial Reporting Centre (FRC):**\n'
                  '• Website: www.frc.go.ke\n'
                  '• Email: frc@frc.go.ke\n\n'
                  '**Kenya Revenue Authority (KRA):**\n'
                  '• Website: www.kra.go.ke\n'
                  '• Phone: +254 20 281 0000',
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
