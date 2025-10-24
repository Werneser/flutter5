// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../app.dart';
import '../widgets/profile_screen_change.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _imageUrls = const [
    'https://images.unsplash.com/photo-1517816428104-797678c7cf0d?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?q=80&w=1080&auto=format&fit=crop',
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

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProfileScreenChange(
          initialFullName: p.fullName,
          initialPassport: p.passport,
          initialSnils: p.snils,
          initialPhone: p.phone,
          initialEmail: p.email,
        ),
      ),
    );

    if (updated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлён')),
      );
    }
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
                      // Доп. тюнинг (опционально):
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

