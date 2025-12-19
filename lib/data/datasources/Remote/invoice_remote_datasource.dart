import 'package:dio/dio.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';

class InvoiceRemoteDataSource {
  final Dio _dio;
  final AuthRemoteDataSource _authRemoteDataSource;

  InvoiceRemoteDataSource(this._dio, this._authRemoteDataSource);

  Future<String?> _getCurrentUserLogin() async {
    return await _authRemoteDataSource.getCurrentUserLogin();
  }

  Future<List<Invoice>> getInvoices() async {
    final login = await _getCurrentUserLogin();
    if (login == null) {
      return [];
    }

    try {
      final response = await _dio.get(
        '/invoices/user/$login',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Invoice.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }


  Future<void> updateInvoiceStatus({
    required String invoiceId,
    required InvoiceStatus status,
  }) async {
    try {
      await _dio.patch(
        '/invoices/$invoiceId/status',
        queryParameters: {'status': status.index},
      );
    } catch (e) {
      throw Exception('Failed to update invoice status: $e');
    }
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      final response = await _dio.post(
        '/invoices',
        data: {
          'user': await _getCurrentUserLogin(),
          'serviceName': invoice.serviceName,
          'invoiceNumber': invoice.invoiceNumber,
          'status': invoice.status.index,
          'amount': invoice.amount,
          'issueAddress': invoice.issueAddress,
          'destinationAddress': invoice.destinationAddress,
        },
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create invoice: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }
}
