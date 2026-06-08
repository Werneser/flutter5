import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../widgets/appointment_list_view.dart';
import 'employee_appointment_detail_screen.dart';

class EmployeeAppointmentListScreen extends StatefulWidget {
  const EmployeeAppointmentListScreen({super.key});

  @override
  State<EmployeeAppointmentListScreen> createState() => _EmployeeAppointmentListScreenState();
}

class _EmployeeAppointmentListScreenState extends State<EmployeeAppointmentListScreen> {
  AppointmentStatus? _status;
  List<Appointment> _allAppointments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllAppointments();
  }

  Future<void> _loadAllAppointments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final appointmentDataSource = GetIt.I<AppointmentRemoteDataSource>();
      final appointments = await appointmentDataSource.getAllAppointments();

      if (mounted) {
        setState(() {
          _allAppointments = _status != null
              ? appointments.where((a) => a.status == _status).toList()
              : appointments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все заявки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllAppointments,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _StatusFilter(
              selected: _status,
              onSelected: (st) {
                setState(() => _status = st);
                _loadAllAppointments();
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Ошибка загрузки: $_error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAllAppointments,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
                  : _allAppointments.isEmpty
                  ? const Center(child: Text('Нет заявок'))
                  : ListView.separated(
                itemCount: _allAppointments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final appointment = _allAppointments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(appointment.status),
                      child: Icon(
                        _getStatusIcon(appointment.status),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(appointment.service.title),
                    subtitle: Text('Статус: ${appointment.status.label}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => EmployeeAppointmentDetailScreen(
                            appointment: appointment,
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadAllAppointments();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
}

class _StatusFilter extends StatelessWidget {
  final AppointmentStatus? selected;
  final ValueChanged<AppointmentStatus?> onSelected;

  const _StatusFilter({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [null, ...AppointmentStatus.values];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final st in statuses)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(st == null ? 'Все' : st.label),
                selected: selected == st,
                onSelected: (_) => onSelected(st),
              ),
            ),
        ],
      ),
    );
  }
}