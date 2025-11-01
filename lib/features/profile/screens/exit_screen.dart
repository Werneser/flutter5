import 'package:flutter/material.dart';

class ExitScreen extends StatelessWidget {
  const ExitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выход'),
      ),
      body: const Center(
        child: Text(
          'Выход из приложения',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}