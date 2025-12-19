import 'package:flutter5/data/datasources/Local/invoice_local_datasource.dart';

class DeleteInvoiceUseCase {
  final InvoiceLocalDataSource invoiceLocalDataSource;

  DeleteInvoiceUseCase(this.invoiceLocalDataSource);

  Future<void> execute(String id) async {
    await invoiceLocalDataSource.deleteInvoice(id);
  }
}
