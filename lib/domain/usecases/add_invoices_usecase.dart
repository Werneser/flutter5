import 'package:flutter5/data/datasources/Local/invoice_local_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class AddInvoiceUseCase {
  final InvoiceLocalDataSource invoiceLocalDataSource;

  AddInvoiceUseCase(this.invoiceLocalDataSource);

  Future<void> execute(Invoice invoice) async {
    await invoiceLocalDataSource.addInvoice(invoice);
  }
}
