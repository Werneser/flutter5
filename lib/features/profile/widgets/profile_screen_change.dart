// profile_screen_change.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// См. комментарий в profile_screen.dart — ожидается совместимый AppState.
abstract class AppState extends ChangeNotifier {
  String? get fullName;
  String? get email;
  String? get phone;
  String? get bio;

  void updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? bio,
  });
}

class ProfileScreenChange extends StatefulWidget {
  const ProfileScreenChange({
    super.key,
    required this.initialFullName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialBio,
  });

  final String initialFullName;
  final String initialEmail;
  final String initialPhone;
  final String initialBio;

  @override
  State<ProfileScreenChange> createState() => _ProfileScreenChangeState();
}

class _ProfileScreenChangeState extends State<ProfileScreenChange> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialFullName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _bioCtrl = TextEditingController(text: widget.initialBio);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final appState = context.read<AppState>();
      appState.updateProfile(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(true); // Сообщаем, что обновили
      }
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
      appBar: AppBar(
        title: const Text('Изменить профиль'),
      ),
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
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Укажите имя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Укажите e-mail';
                          final emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Некорректный e-mail';
                          }
                          return null;
                        },
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
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return null; // телефон опционален
                          final phoneRegex = RegExp(r'^[0-9\+\-\s\(\)]{6,}$');
                          if (!phoneRegex.hasMatch(value)) {
                            return 'Некорректный телефон';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _bioCtrl,
                        decoration: const InputDecoration(
                          labelText: 'О себе',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        textInputAction: TextInputAction.newline,
                        maxLines: 4,
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
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}