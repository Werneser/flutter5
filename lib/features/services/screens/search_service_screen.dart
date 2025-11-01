import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchServiceScreen extends StatefulWidget {
  const SearchServiceScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SearchServiceScreen> createState() => _SearchServiceScreenState();
}

class _SearchServiceScreenState extends State<SearchServiceScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {

    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск услуг'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Применить поиск',
            onPressed: _apply,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите запрос',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (_) => _apply(),
          controller: _controller,
        ),
      ),
    );
  }
}