
import 'package:flutter/material.dart';
import 'package:flutter5/data/statechange/AppStateScope.dart';


class ProfileScreenChange extends StatefulWidget {
  const ProfileScreenChange({
    super.key,
    required this.initialFullName,
    required this.initialPassport,
    required this.initialSnils,
    required this.initialPhone,
    required this.initialEmail,
  });

  final String initialFullName;
  final String initialPassport;
  final String initialSnils;
  final String initialPhone;
  final String initialEmail;

  @override
  State<ProfileScreenChange> createState() => _ProfileScreenChangeState();
}

class _ProfileScreenChangeState extends State<ProfileScreenChange> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _passportCtrl;
  late final TextEditingController _snilsCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialFullName);
    _passportCtrl = TextEditingController(text: widget.initialPassport);
    _snilsCtrl = TextEditingController(text: widget.initialSnils);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final appState = AppStateScope.of(context);
      final current = appState.profile;

      final updated = current.copyWith(
        fullName: _nameCtrl.text.trim(),
        passport: _passportCtrl.text.trim(),
        snils: _snilsCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
      );

      appState.updateProfile(updated);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось сохранить: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Изменить профиль')),
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: _saving,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Полное имя',
                          prefixIcon: Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Укажите имя' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passportCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Паспорт (серия и номер)',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _snilsCtrl,
                        decoration: const InputDecoration(
                          labelText: 'СНИЛС',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Телефон',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Укажите e-mail';
                          final re = RegExp(r'^[\w.\-]+@[\w.\-]+\.\w+$');
                          return re.hasMatch(value) ? null : 'Некорректный e-mail';
                        },
                        onFieldSubmitted: (_) => _save(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save),
                          label: const Text('Сохранить'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_saving)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x33000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}