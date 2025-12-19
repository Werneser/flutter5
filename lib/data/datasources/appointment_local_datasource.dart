import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter5/domain/models/appointment.dart';

class AppointmentLocalDataSource {
  static const _keyPrefix = 'appointmentLocalDataSource';
  final FlutterSecureStorage _storage;

  AppointmentLocalDataSource(this._storage);

  Future<List<Appointment>> getAppointments(String userId) async {
    final jsonString = await _storage.read(key: '${_keyPrefix}$userId');
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Appointment.fromJson(json)).toList();
  }

  Future<void> saveAppointments(String userId, List<Appointment> Appointments) async {
    final jsonString = json.encode(Appointments.map((e) => e.toJson()).toList());
    await _storage.write(key: '${_keyPrefix}$userId', value: jsonString);
  }

  Future<void> addAppointment(String userId, Appointment Appointment) async {
    final Appointments = await getAppointments(userId);
    Appointments.add(Appointment);
    await saveAppointments(userId, Appointments);
  }

  Future<void> updateAppointmentStatus({
    required String userId,
    required String AppointmentId,
    required AppointmentStatus status,
  }) async {
    final Appointments = await getAppointments(userId);
    final index = Appointments.indexWhere((e) => e.id == AppointmentId);
    if (index != -1) {
      Appointments[index] = Appointments[index].copyWith(status: status);
      await saveAppointments(userId, Appointments);
    }
  }

  Future<List<Appointment>> getAppointmentsByStatus(String userId, AppointmentStatus? status) async {
    final Appointments = await getAppointments(userId);
    if (status == null) return Appointments;
    return Appointments.where((e) => e.status == status).toList();
  }
}
