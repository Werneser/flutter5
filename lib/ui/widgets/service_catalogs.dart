import 'package:flutter/material.dart';

import '../../domain/models/service.dart';



class ServiceCatalogs extends StatelessWidget {
  final ServiceCategory? selected;
  final ValueChanged<ServiceCategory?> onSelected;

  const ServiceCatalogs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cats = [null, ...ServiceCategory.values];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 4),
          for (final cat in cats)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(cat == null ? 'Все' : cat.label),
                selected: selected == cat,
                onSelected: (_) => onSelected(cat),
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}