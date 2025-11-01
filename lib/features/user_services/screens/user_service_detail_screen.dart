import 'package:flutter/material.dart';
import '../../services/models/service.dart';
import '../models/user_service.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({Key? key, required this.userService}) : super(key: key);

  final UserService userService;

  @override
  Widget build(BuildContext context) {
    final service = userService.service;

    return Scaffold(
      appBar: AppBar(
        title: Text(service.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(service.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(service.description),
            const SizedBox(height: 16),
            Text('Класс: ${service.category.label}'), // если есть
            const SizedBox(height: 12),
            Text('Заявка: ${userService.appliedAt.toLocal()}'), // формат можно улучшить
            const SizedBox(height: 12),
            Text('Статус: ${userService.status.label}'),
            const SizedBox(height: 12),
            if (userService.formData.isNotEmpty) ...[
              const Text('Данные формы:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (final e in userService.formData.entries)
                ListTile(
                  title: Text(e.key),
                  subtitle: Text(e.value),
                ),
            ],
          ],
        ),
      ),
    );
  }
}