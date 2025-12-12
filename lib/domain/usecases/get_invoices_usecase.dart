import 'package:flutter5/data/datasources/invoice_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class GetInvoicesUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource;

  GetInvoicesUseCase(this.invoiceRemoteDataSource);

  List<Invoice> execute() {
    return invoiceRemoteDataSource.getInvoices();
  }
}
