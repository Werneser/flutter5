import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../widgets/appointment_list_view.dart';

class UserServiceListScreen extends StatefulWidget {
  const UserServiceListScreen({super.key});

  @override
  State<UserServiceListScreen> createState() => _UserServiceListScreenState(GetIt.I<AppointmentRemoteDataSource>());
}

class _UserServiceListScreenState extends State<UserServiceListScreen> {
  AppointmentStatus? _status;
  final AppointmentRemoteDataSource userServiceRemoteDataSource;

  _UserServiceListScreenState(this.userServiceRemoteDataSource);

  void _goToProfile() {
    GoRouter.of(context).go('/profile');
  }

  void _openStatusChangeFor(Appointment service) {
    GoRouter.of(context).push<AppointmentStatus?>('/statusChange', extra: service).then((result) {
      if (result != null) {
        userServiceRemoteDataSource.updateAppointmentStatus(
          appointmentId: service.id,
          status: result,
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заявки'),
        actions: [
          IconButton(
            tooltip: 'Профиль',
            icon: const Icon(Icons.person),
            onPressed: _goToProfile,
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
              onSelected: (st) => setState(() => _status = st),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<List<Appointment>>(
                future: userServiceRemoteDataSource.getAppointmentsByStatus(_status),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка загрузки данных: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Нет заявок с выбранным статусом'));
                  }

                  return UserServiceListView(
                    items: snapshot.data!,
                    onTapChangeStatus: (service) async {
                      final result = await GoRouter.of(context).push<AppointmentStatus?>('/statusChange', extra: service);
                      if (result != null) {
                        await userServiceRemoteDataSource.updateAppointmentStatus(
                          appointmentId: service.id,
                          status: result,
                        );
                        setState(() {});
                      }
                    },
                    onTap: (service) async {
                      await GoRouter.of(context).push<void>('/serviceDetail', extra: service);
                    },
                    onSecondaryTap: (service) {
                      _openStatusChangeFor(service);
                    },
                    onChangeStatus: (String value) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
