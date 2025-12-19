import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class AddInvoiceUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource;

  AddInvoiceUseCase(this.invoiceRemoteDataSource);

  Future<void> execute(Invoice invoice) async {
    await invoiceRemoteDataSource.addInvoice(invoice);
  }
}