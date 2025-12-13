import 'package:flutter/material.dart';
import '../../../../domain/models/user_service.dart';

class UserServiceListView extends StatelessWidget {
  final List<UserService> items;
  final ValueChanged<String> onChangeStatus;
  final ValueChanged<UserService> onTap;
  final ValueChanged<UserService> onTapChangeStatus;
  final void Function(UserService)? onSecondaryTap;
  const UserServiceListView({
    required this.items,
    required this.onChangeStatus,
    required this.onTap,
    required this.onTapChangeStatus,
    this.onSecondaryTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final service = items[index];
        return MouseRegion(
          onEnter: (_) {},
          onExit: (_) {},
          child: GestureDetector(
            onTap: () => onTap(service),
            onSecondaryTap: onSecondaryTap != null ? () => onSecondaryTap!(service) : null,
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.description)),
              title: Text(service.service.title),
              subtitle: Text('Статус: ${service.status.label}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }
}