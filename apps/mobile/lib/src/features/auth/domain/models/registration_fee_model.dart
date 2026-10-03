enum PaymentDestinationType {
  mpesaTill,
  mpesaPaybill,
  bankAccount,
  mobileMoney,
}

class RegistrationFeeModel {
  final int amount;
  final String currency;
  final String? description;
  final PaymentDestinationType destinationType;
  final String destinationAccount;
  final String? destinationName;
  final String? destinationBranch;
  final String? destinationReference;

  RegistrationFeeModel({
    required this.amount,
    required this.currency,
    this.description,
    required this.destinationType,
    required this.destinationAccount,
    this.destinationName,
    this.destinationBranch,
    this.destinationReference,
  });

  factory RegistrationFeeModel.fromJson(Map<String, dynamic> json) {
    return RegistrationFeeModel(
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      description: json['description'] as String?,
      destinationType: _parseDestinationType(json['destinationType'] as String?),
      destinationAccount: json['destinationAccount'] as String,
      destinationName: json['destinationName'] as String?,
      destinationBranch: json['destinationBranch'] as String?,
      destinationReference: json['destinationReference'] as String?,
    );
  }

  static PaymentDestinationType _parseDestinationType(String? type) {
    switch (type) {
      case 'MPESA_TILL':
        return PaymentDestinationType.mpesaTill;
      case 'MPESA_PAYBILL':
        return PaymentDestinationType.mpesaPaybill;
      case 'BANK_ACCOUNT':
        return PaymentDestinationType.bankAccount;
      case 'MOBILE_MONEY':
        return PaymentDestinationType.mobileMoney;
      default:
        return PaymentDestinationType.mpesaTill;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'description': description,
      'destinationType': _destinationTypeToString(destinationType),
      'destinationAccount': destinationAccount,
      'destinationName': destinationName,
      'destinationBranch': destinationBranch,
      'destinationReference': destinationReference,
    };
  }

  static String _destinationTypeToString(PaymentDestinationType type) {
    switch (type) {
      case PaymentDestinationType.mpesaTill:
        return 'MPESA_TILL';
      case PaymentDestinationType.mpesaPaybill:
        return 'MPESA_PAYBILL';
      case PaymentDestinationType.bankAccount:
        return 'BANK_ACCOUNT';
      case PaymentDestinationType.mobileMoney:
        return 'MOBILE_MONEY';
    }
  }

  double get amountInMajorUnit => amount / 100.0;

  String get destinationTypeLabel {
    switch (destinationType) {
      case PaymentDestinationType.mpesaTill:
        return 'M-Pesa Till';
      case PaymentDestinationType.mpesaPaybill:
        return 'M-Pesa Paybill';
      case PaymentDestinationType.bankAccount:
        return 'Bank Account';
      case PaymentDestinationType.mobileMoney:
        return 'Mobile Money';
    }
  }
}

class RegistrationFeeStatusModel {
  final bool paid;
  final String status;
  final int? amount;
  final String? currency;
  final DateTime? processedAt;

  RegistrationFeeStatusModel({
    required this.paid,
    required this.status,
    this.amount,
    this.currency,
    this.processedAt,
  });

  factory RegistrationFeeStatusModel.fromJson(Map<String, dynamic> json) {
    return RegistrationFeeStatusModel(
      paid: json['paid'] as bool,
      status: json['status'] as String,
      amount: json['amount'] as int?,
      currency: json['currency'] as String?,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paid': paid,
      'status': status,
      'amount': amount,
      'currency': currency,
      'processedAt': processedAt?.toIso8601String(),
    };
  }
}