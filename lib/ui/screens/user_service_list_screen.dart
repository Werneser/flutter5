import 'package:flutter/material.dart';
import 'package:flutter5/data/statechange/AppStateScope.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/user_service.dart';
import '../widgets/user_service_list_view.dart';

class UserServiceListScreen extends StatefulWidget {
  const UserServiceListScreen({super.key});

  @override
  State<UserServiceListScreen> createState() => _UserServiceListScreenState();
}

class _UserServiceListScreenState extends State<UserServiceListScreen> {
  UserServiceStatus? _status;

  void _goToProfile() {
    GoRouter.of(context).go('/profile');
  }

  void _openStatusChangeFor(UserService service) {
    GoRouter.of(context).push<UserServiceStatus?>(
      '/statusChange',
      extra: service,
    ).then((result) {
      if (result != null) {
        final app = AppStateScope.of(context);
        app.updateUserServiceStatus(
          userServiceId: service.id,
          status: result,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final items = app.userServicesByStatus(_status);

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
              child: UserServiceListView(
                items: items,
                onTapChangeStatus: (service) async {
                  final result = await GoRouter.of(context).push<UserServiceStatus?>(
                    '/statusChange',
                    extra: service,
                  );
                  if (result != null) {
                    app.updateUserServiceStatus(
                      userServiceId: service.id,
                      status: result,
                    );
                  }
                },
                onTap: (service) async {
                  await GoRouter.of(context).push<void>(
                    '/serviceDetail',
                    extra: service,
                  );
                },
                onSecondaryTap: (service) {
                  _openStatusChangeFor(service);
                },
                onChangeStatus: (String value) {},
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