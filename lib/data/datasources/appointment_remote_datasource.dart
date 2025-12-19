import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter5/domain/models/appointment.dart';

class AppointmentRemoteDataSource {
  final Dio _dio;
  final AuthRemoteDataSource _authRemoteDataSource;

  AppointmentRemoteDataSource(this._dio, this._authRemoteDataSource);

  Future<String?> _getCurrentUserLogin() async {
    return await _authRemoteDataSource.getCurrentUserLogin();
  }

  Future<List<Appointment>> getAppointmentsByStatus(AppointmentStatus? status) async {
    final login = await _getCurrentUserLogin();
    if (login == null) {
      return [];
    }

    try {
      final response = await _dio.get(
        '/appointments/user/$login',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required AppointmentStatus status,
  }) async {
    try {
      await _dio.patch(
        '/appointments/$appointmentId/status',
        queryParameters: {'status': status.index},
      );
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      final response = await _dio.post(
        '/appointments',
        data: {
          'user': await _getCurrentUserLogin(),
          'service': {
            'id': appointment.service.id,
            'title': appointment.service.title,
            'description': appointment.service.description,
            'category': appointment.service.category.index,
            'requiredFields': appointment.service.requiredFields,
          },
          'formData': appointment.formData,
        },
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create appointment: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }
}
