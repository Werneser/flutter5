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
}
