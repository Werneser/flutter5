import 'package:flutter/material.dart';

import '../../../app.dart';

import '../models/user_service.dart';
import '../widgets/user_service_list_view.dart';
import 'status_change_screen.dart'; // новая страница для изменения статуса

class UserServiceListScreen extends StatefulWidget {
  const UserServiceListScreen({super.key});

  @override
  State<UserServiceListScreen> createState() => _UserServiceListScreenState();
}

class _UserServiceListScreenState extends State<UserServiceListScreen> {
  UserServiceStatus? _status;

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final items = app.userServicesByStatus(_status);

    return Scaffold(
      appBar: AppBar(title: const Text('Мои заявки')),
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
              child: UserServiceListView(
                items: items,
                onChangeStatus: (id, newStatus) {
                  app.updateUserServiceStatus(
                    userServiceId: id,
                    status: newStatus,
                  );
                },
                onTapChangeStatus: (service) async {
                  // Переходим на страницу изменения статуса и возвращаем результат
                  final result = await Navigator.of(context).push<UserServiceStatus?>(
                    MaterialPageRoute(
                      builder: (_) => StatusChangeScreen(service: service),
                    ),
                  );
                  if (result != null) {
                    app.updateUserServiceStatus(
                      userServiceId: service.id,
                      status: result,
                    );
                  }
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
  final UserServiceStatus? selected;
  final ValueChanged<UserServiceStatus?> onSelected;

  const _StatusFilter({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [null, ...UserServiceStatus.values];

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