import 'package:flutter/material.dart';

import '../../../../domain/models/service.dart';


class ServiceListView extends StatelessWidget {
  final List<Service> services;
  final ValueChanged<Service> onTap;

  const ServiceListView({
    super.key,
    required this.services,
    required this.onTap,
  });

  IconData _iconFor(ServiceCategory c) {
    switch (c) {
      case ServiceCategory.transport:
        return Icons.directions_car;
      case ServiceCategory.healthcare:
        return Icons.local_hospital;
      case ServiceCategory.education:
        return Icons.school;
      case ServiceCategory.housing:
        return Icons.home_work;
      case ServiceCategory.taxes:
        return Icons.receipt_long;
      case ServiceCategory.documents:
        return Icons.badge;
      case ServiceCategory.family:
        return Icons.family_restroom;
      case ServiceCategory.property:
        return Icons.apartment;
      case ServiceCategory.business:
        return Icons.business_center;
      case ServiceCategory.other:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(child: Text('Ничего не найдено'));
    }
    return ListView.separated(
      itemCount: services.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final s = services[index];
        return ListTile(
          leading: CircleAvatar(
            child: Icon(_iconFor(s.category)),
          ),
          title: Text(s.title),
          subtitle: Text(s.description),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onTap(s),
        );
      },
    );
  }
}