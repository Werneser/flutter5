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
      'status': status.index,
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
      status: _parseInvoiceStatusFromIndex(json['status']),
      amount: (json['amount'] as num).toDouble(),
      issueAddress: json['issueAddress'],
      destinationAddress: json['destinationAddress'],
    );
  }

  static InvoiceStatus _parseInvoiceStatusFromIndex(int statusIndex) {
    switch (statusIndex) {
      case 0:
        return InvoiceStatus.unpaid;
      case 1:
        return InvoiceStatus.paid;
      case 2:
        return InvoiceStatus.overdue;
      default:
        throw Exception('Unknown InvoiceStatus index: $statusIndex');
    }
  }
}
