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

  Future<String?> _getToken() async {
    return await _authRemoteDataSource.getToken();
  }

  Future<List<Invoice>> getInvoices() async {
    final login = await _getCurrentUserLogin();
    if (login == null) {
      return [];
    }

    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/invoices/user/$login',
        options: Options(
          headers: {
            'Authorization': token ?? '',
          },
        ),
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
      final token = await _getToken();
      await _dio.patch(
        '/invoices/$invoiceId/status',
        queryParameters: {'status': status.index},
        options: Options(
          headers: {
            'Authorization': token ?? '',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to update invoice status: $e');
    }
  }

  Future<void> addInvoice(Invoice invoice, {String? userName}) async {
    try {
      final token = await _getToken();
      final user = userName ?? await _getCurrentUserLogin();

      final response = await _dio.post(
        '/invoices',
        data: {
          'user': user,
          'serviceName': invoice.serviceName,
          'invoiceNumber': invoice.invoiceNumber,
          'status': invoice.status.index,
          'amount': invoice.amount,
          'issueAddress': invoice.issueAddress,
          'destinationAddress': invoice.destinationAddress,
        },
        options: Options(
          headers: {
            'Authorization': token ?? '',
          },
        ),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create invoice: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }
}