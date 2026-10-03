import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Introduction',
              'PesaLoan Limited ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your personal data when you use our mobile application, in accordance with the Data Protection Act, 2019 of Kenya.',
            ),
            _buildSection(
              '2. Data Controller',
              'PesaLoan Limited is the data controller for your personal data. Our Data Protection Officer can be contacted at:\n'
                  '• Email: dpo@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n'
                  '• Address: PesaLoan Limited, Nairobi, Kenya',
            ),
            _buildSection(
              '3. Data We Collect',
              'We collect the following categories of personal data:\n\n'
                  '**Identity Data:**\n'
                  '• Full name\n'
                  '• Date of birth\n'
                  '• National ID number\n'
                  '• Phone number\n'
                  '• Email address\n\n'
                  '**Financial Data:**\n'
                  '• Loan application details\n'
                  '• Repayment history\n'
                  '• Mobile money transaction records\n'
                  '• Credit score and credit history\n\n'
                  '**Technical Data:**\n'
                  '• Device information (model, OS version)\n'
                  '• App usage data\n'
                  '• IP address\n'
                  '• Location data (with your consent)\n\n'
                  '**KYC Data:**\n'
                  '• ID document images\n'
                  '• Selfie photographs\n'
                  '• Proof of address',
            ),
            _buildSection(
              '4. How We Use Your Data',
              'We use your personal data for the following purposes:\n'
                  '• Loan application processing and credit assessment\n'
                  '• KYC verification and identity confirmation\n'
                  '• Loan disbursement and repayment processing\n'
                  '• Credit reference bureau reporting\n'
                  '• Customer support and communication\n'
                  '• Fraud prevention and security\n'
                  '• Legal and regulatory compliance\n'
                  '• Service improvement and analytics',
            ),
            _buildSection(
              '5. Legal Basis for Processing',
              'We process your personal data on the following legal bases:\n'
                  '• **Contractual necessity:** To provide our lending services\n'
                  '• **Legal obligation:** To comply with CBK regulations, AML laws, and CRB reporting requirements\n'
                  '• **Legitimate interests:** For fraud prevention, security, and service improvement\n'
                  '• **Consent:** For marketing communications and location data (you may withdraw consent at any time)',
            ),
            _buildSection(
              '6. Data Sharing',
              'We may share your personal data with:\n\n'
                  '**Credit Reference Bureaus:**\n'
                  '• TransUnion Africa\n'
                  '• CreditInfo Kenya\n'
                  '• Metropol Credit Reference Bureau\n\n'
                  '**Service Providers:**\n'
                  '• M-Pesa / Safaricom (for loan disbursement and repayment)\n'
                  '• Airtel Money (for loan disbursement and repayment)\n'
                  '• KYC verification providers (Smile Identity, Prembly)\n'
                  '• SMS and email service providers\n\n'
                  '**Regulatory Bodies:**\n'
                  '• Central Bank of Kenya\n'
                  '• Financial Reporting Centre\n'
                  '• Office of the Data Protection Commissioner',
            ),
            _buildSection(
              '7. Data Retention',
              'We retain your personal data for as long as necessary to fulfill the purposes for which it was collected, including:\n'
                  '• Active account data: Duration of your relationship with us\n'
                  '• Loan records: 7 years after loan closure (as required by law)\n'
                  '• KYC data: 7 years after account closure\n'
                  '• Transaction records: 7 years\n\n'
                  'After the retention period, your data will be securely deleted or anonymized.',
            ),
            _buildSection(
              '8. Your Rights',
              'Under the Data Protection Act, 2019, you have the right to:\n'
                  '• **Access:** Request a copy of your personal data\n'
                  '• **Rectification:** Correct inaccurate or incomplete data\n'
                  '• **Erasure:** Request deletion of your personal data\n'
                  '• **Restriction:** Limit how we process your data\n'
                  '• **Objection:** Object to certain processing activities\n'
                  '• **Data portability:** Receive your data in a structured format\n'
                  '• **Withdraw consent:** Withdraw consent at any time\n\n'
                  'To exercise these rights, contact our Data Protection Officer at dpo@PesaLoan.co.ke.',
            ),
            _buildSection(
              '9. Data Security',
              'We implement appropriate technical and organizational measures to protect your personal data, including:\n'
                  '• End-to-end encryption for data in transit\n'
                  '• AES-256 encryption for data at rest\n'
                  '• Secure authentication (PIN, biometric)\n'
                  '• Regular security audits and penetration testing\n'
                  '• Employee training on data protection\n'
                  '• Incident response and breach notification procedures',
            ),
            _buildSection(
              '10. Children\'s Privacy',
              'Our services are not intended for individuals under the age of 18. We do not knowingly collect personal data from minors. If we become aware that we have collected data from a minor, we will take steps to delete it immediately.',
            ),
            _buildSection(
              '11. International Transfers',
              'Your personal data is stored and processed in Kenya. Where we use service providers outside Kenya, we ensure appropriate safeguards are in place, including standard contractual clauses approved by the Office of the Data Protection Commissioner.',
            ),
            _buildSection(
              '12. Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of material changes through the app, SMS, or email at least 14 days before the changes take effect.',
            ),
            _buildSection(
              '13. Contact & Complaints',
              'If you have questions or concerns about this Privacy Policy or our data practices:\n\n'
                  '**Data Protection Officer:**\n'
                  '• Email: dpo@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n\n'
                  '**Office of the Data Protection Commissioner:**\n'
                  '• Website: www.odpc.go.ke\n'
                  '• Email: complaints@odpc.go.ke',
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
