import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class GetInvoicesUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource;

  GetInvoicesUseCase(this.invoiceRemoteDataSource);

  Future<List<Invoice>> execute() async {
    return await invoiceRemoteDataSource.getInvoices();
  }
}
