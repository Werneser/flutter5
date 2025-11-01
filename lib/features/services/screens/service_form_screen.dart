import 'package:flutter/material.dart';
import '../../../app.dart';
import '../models/service.dart';

class ServiceFormScreen extends StatefulWidget {
  final Service? service;

  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  Service? _service;

  static const List<String> _baseFields = [
    'ФИО',
    'Паспорт (серия и номер)',
    'СНИЛС',
    'Телефон',
    'E-mail',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _service ??= widget.service;
    final fields = [
      ..._baseFields,
      ...(_service?.requiredFields ?? const []),
    ];
    for (final f in fields) {
      _controllers.putIfAbsent(f, () => TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final app = AppStateScope.of(context);
    final data = <String, String>{
      for (final e in _controllers.entries) e.key: e.value.text.trim(),
    };

    app.submitApplication(service: _service!, formData: data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заявление отправлено')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final service = _service;

    if (service == null) {
      return const Scaffold(
        body: Center(child: Text('Услуга не найдена')),
      );
    }

    final fields = [
      ..._baseFields,
      ...service.requiredFields,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(service.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView.separated(
            itemCount: fields.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == fields.length) {
                return FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send),
                  label: const Text('Отправить'),
                );
              }

              final field = fields[index];
              final controller = _controllers[field]!;

              TextInputType? type;
              if (field.contains('Телефон')) type = TextInputType.phone;
              if (field.contains('E-mail')) type = TextInputType.emailAddress;

              return TextFormField(
                controller: controller,
                keyboardType: type,
                decoration: InputDecoration(labelText: field),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Заполните поле' : null,
              );
            },
          ),
        ),
      ),
    );
  }
}