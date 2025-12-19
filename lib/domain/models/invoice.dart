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

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      serviceName: json['serviceName'],
      invoiceNumber: json['invoiceNumber'],
      status: _parseInvoiceStatus(json['status']),
      amount: json['amount'],
      issueAddress: json['issueAddress'],
      destinationAddress: json['destinationAddress'],
    );
  }

  static InvoiceStatus _parseInvoiceStatus(String status) {
    switch (status) {
      case 'unpaid':
        return InvoiceStatus.unpaid;
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      default:
        throw Exception('Unknown InvoiceStatus: $status');
    }
  }
}


