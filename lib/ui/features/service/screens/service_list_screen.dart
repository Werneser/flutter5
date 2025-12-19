import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/service_remote_datasource.dart';
import 'package:flutter5/domain/models/service.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../widgets/service_catalogs.dart';
import '../widgets/service_list_view.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState(GetIt.I<ServiceRemoteDataSource>());
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  ServiceCategory? _selectedCategory;
  String _query = '';
  final ServiceRemoteDataSource serviceRemoteDataSource;

  _ServiceListScreenState(this.serviceRemoteDataSource);

  void _goToUserServiceList() {
    GoRouter.of(context).go('/userServiceList');
  }

  Future<void> _openSearchPage() async {
    final result = await GoRouter.of(context).push<String>(
      '/searchService',
      extra: _query,
    );
    if (result != null) {
      setState(() => _query = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = serviceRemoteDataSource.getServices(category: _selectedCategory, query: _query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Услуги'),
        actions: [
          IconButton(
            tooltip: 'Поиск услуг',
            icon: const Icon(Icons.search),
            onPressed: _openSearchPage,
          ),
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
                GoRouter.of(context).push('/serviceForm', extra: service);
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
