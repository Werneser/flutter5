import 'package:flutter/material.dart';

import '../../../app.dart';

import '../../user_services/screens/user_service_list_screen.dart';
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

  void _goToUserServiceList() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const UserServiceListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final services = app.servicesByCategory(_selectedCategory, query: _query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Услуги'),
        actions: [
          IconButton(
            tooltip: 'Мои заявки',
            icon: const Icon(Icons.list_alt),
            onPressed: _goToUserServiceList,
          ),
        ],
      ),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _goToUserServiceList,
                icon: const Icon(Icons.list_alt),
                label: const Text('Перейти к вашим заявкам'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}