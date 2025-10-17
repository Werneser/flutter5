import 'package:flutter/material.dart';

import '../../../app.dart';
import '../models/service.dart';
import '../widgets/service_catalogs.dart';
import '../widgets/service_list_view.dart';



class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  ServiceCategory? _selectedCategory;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final services = app.servicesByCategory(_selectedCategory, query: _query);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Поиск услуги...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ServiceCatalogs(
            selected: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ServiceListView(
            services: services,
            onTap: (service) {
              Navigator.of(context).pushNamed(
                '/serviceForm',
                arguments: service,
              );
            },
          ),
        ),
      ],
    );
  }
}