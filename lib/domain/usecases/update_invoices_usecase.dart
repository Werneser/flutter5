import 'package:flutter5/data/datasources/invoice_local_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class UpdateInvoiceUseCase {
  final InvoiceLocalDataSource invoiceLocalDataSource;

  UpdateInvoiceUseCase(this.invoiceLocalDataSource);

  Future<void> execute(Invoice invoice) async {
    await invoiceLocalDataSource.updateInvoice(invoice);
  }
}
