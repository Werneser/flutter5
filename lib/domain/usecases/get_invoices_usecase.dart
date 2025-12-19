import 'package:flutter5/data/datasources/Local/invoice_local_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class GetInvoicesUseCase {
  final InvoiceLocalDataSource invoiceLocalDataSource;

  GetInvoicesUseCase(this.invoiceLocalDataSource);

  Future<List<Invoice>> execute() async {
    return await invoiceLocalDataSource.getInvoices();
  }
}
