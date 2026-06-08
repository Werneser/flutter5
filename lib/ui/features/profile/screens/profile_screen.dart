import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/profile_remote_datasource.dart';
import 'package:flutter5/domain/models/userProfile.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profileRemoteDataSource = GetIt.I<ProfileRemoteDataSource>();
      final profile = await profileRemoteDataSource.getProfile();

      if (mounted) {
        setState(() {
          _profile = profile ?? UserProfile();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _profile = UserProfile(); // Создаем пустой профиль при ошибке
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openEditScreen() async {
    final profileToEdit = _profile ?? UserProfile();

    final updated = await GoRouter.of(context).push<bool>(
      '/profile/edit',
      extra: profileToEdit,
    );

    if (updated == true && mounted) {
      await _loadProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль обновлён')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            tooltip: 'Редактировать',
            icon: const Icon(Icons.edit),
            // Кнопка всегда активна
            onPressed: _openEditScreen,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    final profile = _profile ?? UserProfile();

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Не удалось загрузить данные с сервера. Вы можете заполнить профиль вручную.',
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Text('Информация', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(profile.fullName?.isNotEmpty == true
                    ? profile.fullName!
                    : 'Имя не указано'),
                subtitle: const Text('Полное имя'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: Text(profile.passport?.isNotEmpty == true
                    ? profile.passport!
                    : 'Паспорт не указан'),
                subtitle: const Text('Паспорт (серия и номер)'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(profile.snils?.isNotEmpty == true
                    ? profile.snils!
                    : 'СНИЛС не указан'),
                subtitle: const Text('СНИЛС'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(profile.phone?.isNotEmpty == true
                    ? profile.phone!
                    : 'Телефон не указан'),
                subtitle: const Text('Телефон'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text(profile.email?.isNotEmpty == true
                    ? profile.email!
                    : 'E-mail не указан'),
                subtitle: const Text('Электронная почта'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}