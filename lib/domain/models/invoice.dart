enum InvoiceStatus {
  unpaid,
  paid,
  overdue,
}

class Invoice {
  final String id;
  final String serviceName;
  final String invoiceNumber;
  final InvoiceStatus status;
  final double amount;
  final String issueAddress;
  final String destinationAddress;

  Invoice({
    required this.id,
    required this.serviceName,
    required this.invoiceNumber,
    required this.status,
    required this.amount,
    required this.issueAddress,
    required this.destinationAddress,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      status: InvoiceStatus.values.firstWhere(
            (e) => e.toString() == 'InvoiceStatus.${json['status']}',
        orElse: () => InvoiceStatus.unpaid,
      ),
      amount: (json['amount'] ?? 0).toDouble(),
      issueAddress: json['issueAddress'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'invoiceNumber': invoiceNumber,
      'status': status.toString().split('.').last,
      'amount': amount,
      'issueAddress': issueAddress,
      'destinationAddress': destinationAddress,
    };
  }
}
