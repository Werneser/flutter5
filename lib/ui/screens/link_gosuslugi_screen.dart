import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/link_gosuslugi_remote_datasource.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkGosuslugiScreen extends StatefulWidget {
  const LinkGosuslugiScreen({super.key});

  @override
  State<LinkGosuslugiScreen> createState() => _LinkGosuslugiScreenState(GetIt.I<LinkGosuslugiRemoteDataSource>());
}

class _LinkGosuslugiScreenState extends State<LinkGosuslugiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final LinkGosuslugiRemoteDataSource linkGosuslugiRemoteDataSource;
  bool _isLoading = false;

  _LinkGosuslugiScreenState(this.linkGosuslugiRemoteDataSource);

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _linkAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await linkGosuslugiRemoteDataSource.linkAccount(
        _loginController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль успешно привязан к аккаунту госуслуг!')),
        );
        context.pop();
      }
    }
  }

  Future<void> _openGosuslugiWebsite() async {
    const url = 'https://www.gosuslugi.ru';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Привязка к госуслугам'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Введите данные от вашего аккаунта на портале госуслуг, чтобы привязать его к этому приложению.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _openGosuslugiWebsite,
                child: const Text.rich(
                  TextSpan(
                    text: 'Если у вас нет аккаунта на ',
                    children: [
                      TextSpan(
                        text: 'gosuslugi.ru',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ', зарегистрируйтесь по ссылке.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Логин или СНИЛС',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите логин или СНИЛС';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _linkAccount,
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Привязать аккаунт'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _openGosuslugiWebsite,
                child: const Text('Перейти на сайт госуслуг'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
