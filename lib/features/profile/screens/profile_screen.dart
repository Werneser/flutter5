// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'profile_screen_change.dart';

// Примерный интерфейс модели состояния.
// Убедитесь, что у вас есть аналогичный класс и он предоставлен через Provider выше по дереву.
abstract class AppState extends ChangeNotifier {
  String? get fullName;
  String? get email;
  String? get phone;
  String? get bio;

  List<String>? get profileImageUrls;

  void updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? bio,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Дефолтные 5+ изображений, если в AppState нет собственных.
  // Используем фиксированные ссылки (например, Unsplash/Picsum).
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
    // После первого фрейма можно безопасно обратиться к context.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      final fromState = appState.profileImageUrls;
      if (fromState != null && fromState.isNotEmpty) {
        setState(() {
          _imageUrls = fromState;
        });
      }
      _prefetchImages();
    });
  }

  Future<void> _prefetchImages() async {
    // Предпрогрев кэша: если есть сеть — изображения попадут в кэш;
    // при офлайне отобразятся из кэша автоматически.
    try {
      for (final url in _imageUrls) {
        // precacheImage кинет в кэш decoded image; если сети нет — просто не прогреет.
        await precacheImage(CachedNetworkImageProvider(url), context);
      }
      if (mounted) {
        setState(() => _prefetched = true);
      }
    } catch (_) {
      // Тихо игнорируем — офлайн/ошибка сети.
      if (mounted) {
        setState(() => _prefetched = false);
      }
    }
  }

  Future<void> _openEditScreen() async {
    final appState = context.read<AppState>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProfileScreenChange(
          initialFullName: appState.fullName ?? '',
          initialEmail: appState.email ?? '',
          initialPhone: appState.phone ?? '',
          initialBio: appState.bio ?? '',
        ),
      ),
    );

    // Если вернулся true — данные обновлены.
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлён')),
      );
      // Можно заново прогреть кэш, если логика меняет и изображения (опционально).
      // await _prefetchImages();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

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
        onRefresh: () async {
          await _prefetchImages();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Информация профиля
              Text(
                'Информация',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(appState.fullName?.trim().isNotEmpty == true
                      ? appState.fullName!.trim()
                      : 'Имя не указано'),
                  subtitle: const Text('Полное имя'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(appState.email?.trim().isNotEmpty == true
                      ? appState.email!.trim()
                      : 'E-mail не указан'),
                  subtitle: const Text('Электронная почта'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(appState.phone?.trim().isNotEmpty == true
                      ? appState.phone!.trim()
                      : 'Телефон не указан'),
                  subtitle: const Text('Номер телефона'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(appState.bio?.trim().isNotEmpty == true
                      ? appState.bio!.trim()
                      : 'О себе не указано'),
                  subtitle: const Text('Био'),
                ),
              ),

              const SizedBox(height: 16),
              // Галерея с кэшируемыми изображениями
              Row(
                children: [
                  Text(
                    'Фото (офлайн-кэш)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 8),
                  if (_prefetched)
                    const Icon(Icons.cloud_done, size: 20, color: Colors.green)
                  else
                    const Icon(Icons.cloud_download, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _imageUrls.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 в ряд
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
                      // Плейсхолдер при загрузке
                      placeholder: (context, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      // Виджет при ошибке (если нет сети и нет кэша)
                      errorWidget: (context, _, __) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Подсказка пользователю
              Text(
                'Подсказка: изображения кэшируются автоматически. '
                    'Если вы открыли экран онлайн, затем отключили интернет — они продолжат отображаться из кэша.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}