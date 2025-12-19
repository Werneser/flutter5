import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class UpdateInvoiceUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource;

  UpdateInvoiceUseCase(this.invoiceRemoteDataSource);

  Future<void> execute(Invoice invoice) async {
    await invoiceRemoteDataSource.updateInvoiceStatus(
      invoiceId: invoice.id,
      status: invoice.status,
    );
  }
}