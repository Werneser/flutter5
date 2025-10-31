import 'package:flutter/material.dart';
import '../models/user_service.dart';

class UserServiceListView extends StatelessWidget {
  final List<UserService> items;
  final void Function(String id, UserServiceStatus newStatus) onChangeStatus;
  final void Function(UserService service)? onTapChangeStatus; // новый параметр

  const UserServiceListView({
    Key? key,
    required this.items,
    required this.onChangeStatus,
    this.onTapChangeStatus, // добавлено
  }) : super(key: key);

  Color _statusColor(BuildContext context, UserServiceStatus s) {
    final cs = Theme
        .of(context)
        .colorScheme;
    switch (s) {
      case UserServiceStatus.submitted:
        return cs.secondary;
      case UserServiceStatus.inReview:
        return cs.tertiary;
      case UserServiceStatus.approved:
        return Colors.green;
      case UserServiceStatus.rejected:
        return Colors.red;
      case UserServiceStatus.needsInfo:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('У вас пока нет заявлений'));
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final e = items[index];
        return ListTile(
          title: Text(e.service.title),
          subtitle: Text(
              '${e.status.label} • подано ${_formatDateTime(e.appliedAt)}'),
          trailing: Chip(
            avatar: CircleAvatar(
              backgroundColor: _statusColor(context, e.status),
              radius: 6,
            ),
            label: Text(e.status.label),
          ),
          onTap: () => _showActionSheet(context, e),
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(
        d.minute)}';
  }

  void _showActionSheet(BuildContext context, UserService e) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            // ограничиваем высоту BotttomSheet, чтобы не было переполнения
            height: MediaQuery
                .of(context)
                .size
                .height * 0.38,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Детали'),
                  subtitle: Text('ID: ${e.id}'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.hourglass_bottom),
                  title: const Text('Пометить как "В обработке"'),
                  onTap: () {
                    Navigator.pop(context);
                    onChangeStatus(e.id, UserServiceStatus.inReview);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Пометить как "Одобрено"'),
                  onTap: () {
                    Navigator.pop(context);
                    onChangeStatus(e.id, UserServiceStatus.approved);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.highlight_off),
                  title: const Text('Пометить как "Отклонено"'),
                  onTap: () {
                    Navigator.pop(context);
                    onChangeStatus(e.id, UserServiceStatus.rejected);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: const Text('Требуются данные'),
                  onTap: () {
                    Navigator.pop(context);
                    onChangeStatus(e.id, UserServiceStatus.needsInfo);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Изменить статус через страницу'),
                  onTap: () {
                    Navigator.pop(context);
                    onTapChangeStatus?.call(e);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}