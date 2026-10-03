import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class CrbDisclosureScreen extends ConsumerWidget {
  const CrbDisclosureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRB Disclosure')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Credit Reference Bureau (CRB) Disclosure',
              'In accordance with the Central Bank of Kenya (Credit Reference Bureau) Regulations, 2020, PesaLoan Limited is required to inform you about how your credit information is shared with licensed Credit Reference Bureaus (CRBs) in Kenya.',
            ),
            _buildSection(
              'What is a CRB?',
              'A Credit Reference Bureau is a company licensed by the Central Bank of Kenya to collect, collate, and disseminate credit information about borrowers. CRBs maintain credit reports that lenders use to assess creditworthiness.',
            ),
            _buildSection(
              'Licensed CRBs in Kenya',
              'PesaLoan reports credit information to the following licensed CRBs:\n\n'
                  '• **TransUnion Africa**\n'
                  '  Website: www.transunionafrica.com\n'
                  '  Phone: +254 20 760 3700\n\n'
                  '• **CreditInfo Kenya**\n'
                  '  Website: www.creditinfo.co.ke\n'
                  '  Phone: +254 20 222 2222\n\n'
                  '• **Metropol Credit Reference Bureau**\n'
                  '  Website: www.metropol.co.ke\n'
                  '  Phone: +254 20 269 9999',
            ),
            _buildSection(
              'Information Reported',
              'We report the following information to CRBs:\n\n'
                  '**Positive Information:**\n'
                  '• Loan amount and term\n'
                  '• Timely repayments\n'
                  '• Loan closure (paid in full)\n\n'
                  '**Negative Information:**\n'
                  '• Missed payments\n'
                  '• Defaulted loans\n'
                  '• Late payment penalties\n'
                  '• Loan write-offs',
            ),
            _buildSection(
              'How CRB Information is Used',
              'Your credit report is used by:\n'
                  '• Lenders to assess your creditworthiness\n'
                  '• You to track your credit history\n'
                  '• Financial institutions to make lending decisions\n\n'
                  'A good credit history can help you access larger loans and better terms in the future.',
            ),
            _buildSection(
              'Your Rights',
              'Under the CBK (Credit Reference Bureau) Regulations, 2020, you have the right to:\n\n'
                  '• **Access your credit report:** Request a copy from any licensed CRB\n'
                  '• **Dispute inaccurate information:** File a dispute with the CRB\n'
                  '• **Be notified before negative reporting:** We will notify you before reporting negative information\n'
                  '• **Confidentiality:** Your credit information is kept confidential',
            ),
            _buildSection(
              'How to Access Your Credit Report',
              'You can obtain your credit report from any licensed CRB:\n\n'
                  '**TransUnion Africa:**\n'
                  '• Dial *434# on your phone\n'
                  '• Visit www.transunionafrica.com\n\n'
                  '**CreditInfo Kenya:**\n'
                  '• Visit www.creditinfo.co.ke\n'
                  '• Email: info@creditinfo.co.ke\n\n'
                  '**Metropol:**\n'
                  '• Visit www.metropol.co.ke\n'
                  '• Email: info@metropol.co.ke',
            ),
            _buildSection(
              'Disputing Inaccurate Information',
              'If you believe your credit report contains inaccurate information:\n\n'
                  '1. Contact the CRB directly to file a dispute\n'
                  '2. The CRB will investigate within 14 days\n'
                  '3. If the information is found to be inaccurate, it will be corrected\n'
                  '4. You will be notified of the outcome\n\n'
                  'You may also contact PesaLoan support to dispute information we have reported.',
            ),
            _buildSection(
              'Building a Good Credit History',
              'Tips for maintaining a good credit score:\n\n'
                  '• Repay your loans on time\n'
                  '• Avoid defaulting on loans\n'
                  '• Keep your borrowing within your means\n'
                  '• Check your credit report regularly\n'
                  '• Dispute any inaccuracies promptly',
            ),
            _buildSection(
              'Contact Information',
              'For questions about CRB reporting:\n\n'
                  '**PesaLoan Support:**\n'
                  '• Email: support@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n\n'
                  '**Central Bank of Kenya:**\n'
                  '• Website: www.centralbank.go.ke\n'
                  '• Email: cbk@centralbank.go.ke',
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
