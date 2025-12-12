import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';

import '../../services/screens/service_list_screen.dart';
import 'profile_screen_change.dart';
import 'about_govservices_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _imageUrls = const [
    'https://proverk.ru/uploads/images/proverka-snils-1723130846.jpg',
    'https://s.kdelo.ru/images/Karina_Pics/passport_min.png',
    'https://static.tildacdn.com/tild3761-6439-4931-b835-353531616233/610067_47fb143b6eebd.jpg',
    'https://blogkadrovika.ru/wp-content/uploads/%D0%A1%D0%BF%D1%80%D0%B0%D0%B2%D0%BA%D0%B0-%D1%81-%D0%BC%D0%B5%D1%81%D1%82%D0%B0-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%8B.png',
    'https://upload.wikimedia.org/wikipedia/commons/9/92/%D0%9F%D0%BE%D0%BB%D0%B8%D1%81_%D0%9E%D0%9C%D0%A1_%D0%A0%D0%A4.jpeg',
  ];

  bool _prefetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefetchImages());
  }

  Future<void> _prefetchImages() async {
    try {
      for (final url in _imageUrls) {
        await precacheImage(CachedNetworkImageProvider(url), context);
      }
      if (mounted) setState(() => _prefetched = true);
    } catch (_) {
      if (mounted) setState(() => _prefetched = false);
    }
  }

  Future<void> _openEditScreen() async {
    final appState = AppStateScope.of(context);
    final p = appState.profile;
    final updated = await GoRouter.of(context).push<bool>(
      '/profile/edit',
      extra: {
        'fullName': p.fullName,
        'passport': p.passport,
        'snils': p.snils,
        'phone': p.phone,
        'email': p.email,
      },
    );
    if (updated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлён')),
      );
    }
  }
  void _navigateToAboutScreen() {
    GoRouter.of(context).go('/about');
  }
  void _navigateToServiceListScreen() {
    GoRouter.of(context).go('/ServiceList');
  }
  void _navigateToGovAdsScreen() {
    GoRouter.of(context).go('/govads');
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final profile = appState.profile;

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
              final appState = AppStateScope.of(context);
              appState.setTab(2);
            },
          ),
          IconButton(
            tooltip: 'К списку услуг',
            icon: const Icon(Icons.list_alt),
            onPressed: _navigateToServiceListScreen,
          ),
          IconButton(
            tooltip: 'Реклама госуслуг',
            icon: const Icon(Icons.campaign),
            onPressed: _navigateToGovAdsScreen,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _prefetchImages,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Фото (офлайн-кэш)', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  Icon(
                    _prefetched ? Icons.cloud_done : Icons.cloud_download,
                    size: 20,
                    color: _prefetched ? Colors.green : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _imageUrls.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final url = _imageUrls[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, _, __) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                      fadeInDuration: const Duration(milliseconds: 200),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Подсказка: при первом открытии онлайн изображения кэшируются. '
                    'Затем они будут показываться офлайн прямо из кэша.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


