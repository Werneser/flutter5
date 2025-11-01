import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Госуслуги — Заявления'),
              subtitle: Text(
                'Приложение демонстрирует работу с примитивной моделью сервисов и заявок. Это демо-экран для информирования пользователя о приложении.',
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('Версия'),
              subtitle: Text('1.0.0 (demo)'),
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Безопасность'),
              subtitle: Text('Данные локальные и не являются реальными.'),
            ),
            // Можно добавить больше пунктов по желанию
          ],
        ),
      ),
    );
  }
}