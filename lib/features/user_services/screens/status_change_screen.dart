import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app.dart';
import '../models/user_service.dart';

class StatusChangeScreen extends StatelessWidget {
  final UserService service;
  const StatusChangeScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final current = service.status;
    final statuses = UserServiceStatus.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить статус'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Заявка: ${service.id}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final st in statuses)
                  _StatusChip(
                    status: st,
                    isSelected: st == current,
                    onSelected: () {
                      Navigator.of(context).pop(st);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final UserServiceStatus status;
  final bool isSelected;
  final VoidCallback onSelected;

  const _StatusChip({
    Key? key,
    required this.status,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  Color _color(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
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
    return ChoiceChip(
      label: Text(status.label),
      avatar: CircleAvatar(backgroundColor: _color(context), radius: 6),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}