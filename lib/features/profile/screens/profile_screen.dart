import 'package:flutter/material.dart';

import '../../../app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _passportCtrl;
  late final TextEditingController _snilsCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final profile = AppStateScope.of(context).profile;
    _nameCtrl = TextEditingController(text: profile.fullName);
    _passportCtrl = TextEditingController(text: profile.passport);
    _snilsCtrl = TextEditingController(text: profile.snils);
    _phoneCtrl = TextEditingController(text: profile.phone);
    _emailCtrl = TextEditingController(text: profile.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passportCtrl.dispose();
    _snilsCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final app = AppStateScope.of(context);
    app.updateProfile(app.profile.copyWith(
      fullName: _nameCtrl.text.trim(),
      passport: _passportCtrl.text.trim(),
      snils: _snilsCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранён')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 12.0;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Профиль пользователя',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'ФИО'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Укажите ФИО'
                  : null,
            ),
            SizedBox(height: spacing),
            TextFormField(
              controller: _passportCtrl,
              decoration:
              const InputDecoration(labelText: 'Паспорт (серия и номер)'),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Укажите паспорт' : null,
            ),
            SizedBox(height: spacing),
            TextFormField(
              controller: _snilsCtrl,
              decoration: const InputDecoration(labelText: 'СНИЛС'),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Укажите СНИЛС' : null,
            ),
            SizedBox(height: spacing),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Телефон'),
            ),
            SizedBox(height: spacing),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-mail'),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return null;
                if (!t.contains('@')) return 'Некорректный e-mail';
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}