import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GovAdsScreen extends StatelessWidget {
  const GovAdsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Госуслуги — реклама'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance, size: 72, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 12),
                  Text(
                    'Госуслуги — единая точка доступа к государственным услугам.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Перейдите на сайт госуслуг, чтобы оформить заявления онлайн и получить услуги полезно и быстро.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _launchUrl('https://www.gosuslugi.ru/'),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Перейти на gosuslugi.ru'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}