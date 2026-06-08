import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:flutter5/domain/models/service.dart';
import 'package:get_it/get_it.dart';

class EmployeeAppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;

  const EmployeeAppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<EmployeeAppointmentDetailScreen> createState() => _EmployeeAppointmentDetailScreenState();
}

class _EmployeeAppointmentDetailScreenState extends State<EmployeeAppointmentDetailScreen> {
  late Appointment _appointment;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  Future<void> _updateStatus(AppointmentStatus newStatus) async {
    setState(() => _isUpdating = true);

    try {
      final appointmentDataSource = GetIt.I<AppointmentRemoteDataSource>();
      await appointmentDataSource.updateAppointmentStatus(
        appointmentId: _appointment.id,
        status: newStatus,
      );

      setState(() {
        _appointment = _appointment.copyWith(status: newStatus);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Статус изменен на "${newStatus.label}"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при обновлении статуса: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.submitted:
        return Colors.blue;
      case AppointmentStatus.inReview:
        return Colors.orange;
      case AppointmentStatus.approved:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.red;
      case AppointmentStatus.needsInfo:
        return Colors.amber;
    }
  }

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.submitted:
        return Icons.send;
      case AppointmentStatus.inReview:
        return Icons.hourglass_empty;
      case AppointmentStatus.approved:
        return Icons.check_circle;
      case AppointmentStatus.rejected:
        return Icons.cancel;
      case AppointmentStatus.needsInfo:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заявки'),
        actions: [
          if (_isUpdating)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _appointment.service.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _appointment.service.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          avatar: Icon(
                            Icons.category,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text(_appointment.service.category.label),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Статус заявки',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(_appointment.status),
                          color: _getStatusColor(_appointment.status),
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _appointment.status.label,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(_appointment.status),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Изменить статус',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppointmentStatus.values.map((status) {
                        final isSelected = _appointment.status == status;
                        return ChoiceChip(
                          label: Text(status.label),
                          selected: isSelected,
                          selectedColor: _getStatusColor(status).withOpacity(0.3),
                          onSelected: isSelected || _isUpdating
                              ? null
                              : (_) => _updateStatus(status),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Информация о заявке',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('ID заявки', _appointment.id),
                    const Divider(),
                    _buildInfoRow(
                      'Дата подачи',
                      '${_appointment.appliedAt.day}.${_appointment.appliedAt.month}.${_appointment.appliedAt.year} '
                          '${_appointment.appliedAt.hour}:${_appointment.appliedAt.minute.toString().padLeft(2, '0')}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_appointment.formData.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Данные заявителя',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      ..._appointment.formData.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.value,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if (entry.key != _appointment.formData.entries.last.key)
                                const Divider(),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}