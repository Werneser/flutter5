import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Local/profile_local_datasource.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileRemoteDataSource profileRemoteDataSource;

  _ProfileScreenState() {
    profileRemoteDataSource = GetIt.I<ProfileRemoteDataSource>();
  }

  Future<void> _openEditScreen() async {
    final profile = profileRemoteDataSource.getProfile();
    final updated = await GoRouter.of(context).push<bool>(
      '/profile/edit',
      extra: {
        'fullName': profile.fullName,
        'passport': profile.passport,
        'snils': profile.snils,
        'phone': profile.phone,
        'email': profile.email,
      },
    );

    if (updated == true && mounted) {
      setState(() {}); // Обновляем UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлён')),
      );
    }
  }

  void _navigateToServiceListScreen() {
    GoRouter.of(context).go('/ServiceList');
  }

  void _navigateToLinkGosuslugiScreen() {
    GoRouter.of(context).push('/linkGosuslugi');
  }

  @override
  Widget build(BuildContext context) {
    final profile = profileRemoteDataSource.getProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            tooltip: 'Редактировать',
            icon: const Icon(Icons.edit),
            onPressed: _openEditScreen,
          ),
          IconButton(
            tooltip: 'Техническая поддержка',
            icon: const Icon(Icons.support_agent),
            onPressed: () {
              GoRouter.of(context).go('/support');
            },
          ),
          IconButton(
            tooltip: 'К списку услуг',
            icon: const Icon(Icons.list_alt),
            onPressed: _navigateToServiceListScreen,
          ),
          IconButton(
            tooltip: 'Привязать аккаунт госуслуг',
            icon: const Icon(Icons.link),
            onPressed: _navigateToLinkGosuslugiScreen,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Просто обновляем UI без загрузки картинок
          if (mounted) setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Информация', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(profile.fullName.isNotEmpty ? profile.fullName : 'Имя не указано'),
                  subtitle: const Text('Полное имя'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge),
                  title: Text(profile.passport.isNotEmpty ? profile.passport : 'Паспорт не указан'),
                  subtitle: const Text('Паспорт (серия и номер)'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text(profile.snils.isNotEmpty ? profile.snils : 'СНИЛС не указан'),
                  subtitle: const Text('СНИЛС'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(profile.phone.isNotEmpty ? profile.phone : 'Телефон не указан'),
                  subtitle: const Text('Телефон'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(profile.email.isNotEmpty ? profile.email : 'E-mail не указан'),
                  subtitle: const Text('Электронная почта'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}