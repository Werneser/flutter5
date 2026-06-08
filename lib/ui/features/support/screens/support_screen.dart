import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Local/support_local_datasource.dart';
import 'package:get_it/get_it.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late final SupportRemoteDataSource supportRemoteDataSource;

  final TextEditingController _messageController = TextEditingController();

  _SupportScreenState() {
    supportRemoteDataSource = GetIt.I<SupportRemoteDataSource>();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      supportRemoteDataSource.sendMessage(_messageController.text);
      _messageController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final faq = supportRemoteDataSource.getFAQ();
    final messages = supportRemoteDataSource.getMessages();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Техническая поддержка'),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FAQ'),
              Tab(text: 'Чат'),
            ],
            labelColor: Colors.white,      // Цвет активной вкладки
            unselectedLabelColor: Colors.white70, // Цвет неактивной вкладки (с прозрачностью)
            indicatorColor: Colors.white,  // Цвет индикатора (полоски снизу)
            indicatorWeight: 3.0,          // Толщина индикатора
          ),
        ),
        body: TabBarView(
          children: [
            // FAQ
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: faq.length,
              itemBuilder: (context, index) {
                final item = faq[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(
                      item['question']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
            // Чат
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
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
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}