import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class DeleteInvoiceUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource;

  DeleteInvoiceUseCase(this.invoiceRemoteDataSource);

  Future<void> execute(String invoiceId) async {
    await invoiceRemoteDataSource.updateInvoiceStatus(
      invoiceId: invoiceId,
      status: InvoiceStatus.overdue,
    );
  }
}