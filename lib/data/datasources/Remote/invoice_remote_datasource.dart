import 'package:flutter5/domain/models/invoice.dart';


class InvoiceRemoteDataSource {
  final List<Invoice> _invoices = [
    Invoice(
      id: '1',
      serviceName: 'Оплата коммунальных услуг',
      invoiceNumber: 'INV-2023-001',
      status: InvoiceStatus.unpaid,
      amount: 2500.0,
      issueAddress: 'ул. Ленина, д. 10',
      destinationAddress: 'ул. Ленина, д. 10, кв. 45',
    ),
    Invoice(
      id: '2',
      serviceName: 'Оплата электроэнергии',
      invoiceNumber: 'INV-2023-002',
      status: InvoiceStatus.overdue,
      amount: 1800.0,
      issueAddress: 'ул. Гагарина, д. 15',
      destinationAddress: 'ул. Гагарина, д. 15, кв. 12',
    ),
    Invoice(
      id: '3',
      serviceName: 'Оплата за водоснабжение',
      invoiceNumber: 'INV-2023-003',
      status: InvoiceStatus.paid,
      amount: 1200.0,
      issueAddress: 'ул. Пушкина, д. 20',
      destinationAddress: 'ул. Пушкина, д. 20, кв. 33',
    ),
    Invoice(
      id: '4',
      serviceName: 'Оплата за интернет',
      invoiceNumber: 'INV-2023-004',
      status: InvoiceStatus.unpaid,
      amount: 800.0,
      issueAddress: 'ул. Советская, д. 5',
      destinationAddress: 'ул. Советская, д. 5, кв. 17',
    ),
  ];

  List<Invoice> getInvoices() {
    return _invoices;
  }

  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
  }

  void updateInvoice(Invoice updatedInvoice) {
    final index = _invoices.indexWhere((invoice) => invoice.id == updatedInvoice.id);
    if (index != -1) {
      _invoices[index] = updatedInvoice;
    }
  }

  void deleteInvoice(String id) {
    _invoices.removeWhere((invoice) => invoice.id == id);
  }
}