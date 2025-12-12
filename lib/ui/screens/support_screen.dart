import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, String>> _faq = [
    {
      'question': 'Как восстановить пароль?',
      'answer': 'Чтобы восстановить пароль, перейдите на экран авторизации и нажмите "Забыли пароль?". Следуйте инструкциям на экране.'
    },
    {
      'question': 'Как изменить данные профиля?',
      'answer': 'Вы можете изменить данные профиля, перейдя в раздел "Профиль" и нажав на кнопку "Редактировать".'
    },
    {
      'question': 'Как подать заявку на услугу?',
      'answer': 'Перейдите в раздел "Каталог", выберите нужную услугу и нажмите "Подать заявку".'
    },
    {
      'question': 'Как отследить статус заявки?',
      'answer': 'Все ваши заявки отображаются в разделе "Мои услуги". Выберите нужную заявку, чтобы увидеть её статус.'
    },
  ];

  final List<Map<String, String>> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({'text': _messageController.text, 'isMe': 'true'});
        _messages.add({'text': 'Спасибо за ваше сообщение! Мы ответим в ближайшее время.', 'isMe': 'false'});
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Техническая поддержка'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Чат'),
              Tab(text: 'FAQ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Чат
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message['isMe'] == 'true'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message['isMe'] == 'true'
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(message['text']!),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Введите сообщение...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // FAQ
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _faq.length,
              itemBuilder: (context, index) {
                final item = _faq[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(item['question']!),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(item['answer']!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
