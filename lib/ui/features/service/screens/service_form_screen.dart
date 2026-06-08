import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/service_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/profile_remote_datasource.dart';
import 'package:flutter5/domain/models/userProfile.dart';
import 'package:get_it/get_it.dart';
import '../../../../domain/models/service.dart';

class ServiceFormScreen extends StatefulWidget {
  final Service? service;

  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState(GetIt.I<ServiceRemoteDataSource>());
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  Service? _service;
  final ServiceRemoteDataSource serviceRemoteDataSource;
  UserProfile? _userProfile;
  bool _isLoadingProfile = true;

  _ServiceFormScreenState(this.serviceRemoteDataSource);

  static const List<String> _baseFields = [
    'ФИО',
    'Паспорт (серия и номер)',
    'СНИЛС',
    'Телефон',
    'E-mail',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profileRemoteDataSource = GetIt.I<ProfileRemoteDataSource>();
      final profile = await profileRemoteDataSource.getProfile();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoadingProfile = false;
        });

        // После загрузки профиля инициализируем контроллеры
        _initializeControllers();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
        _initializeControllers();
      }
    }
  }

  void _initializeControllers() {
    _service ??= widget.service;
    final fields = [
      ..._baseFields,
      ...(_service?.requiredFields ?? const []),
    ];

    for (final f in fields) {
      if (!_controllers.containsKey(f)) {
        _controllers[f] = TextEditingController();
      }
    }

    // Подставляем данные из профиля
    _fillProfileData();
  }

  void _fillProfileData() {
    if (_userProfile == null) return;

    // Подставляем данные в соответствующие поля
    if (_controllers.containsKey('ФИО') && _userProfile!.fullName?.isNotEmpty == true) {
      _controllers['ФИО']!.text = _userProfile!.fullName!;
    }

    if (_controllers.containsKey('Паспорт (серия и номер)') && _userProfile!.passport?.isNotEmpty == true) {
      _controllers['Паспорт (серия и номер)']!.text = _userProfile!.passport!;
    }

    if (_controllers.containsKey('СНИЛС') && _userProfile!.snils?.isNotEmpty == true) {
      _controllers['СНИЛС']!.text = _userProfile!.snils!;
    }

    if (_controllers.containsKey('Телефон') && _userProfile!.phone?.isNotEmpty == true) {
      _controllers['Телефон']!.text = _userProfile!.phone!;
    }

    if (_controllers.containsKey('E-mail') && _userProfile!.email?.isNotEmpty == true) {
      _controllers['E-mail']!.text = _userProfile!.email!;
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

    final data = <String, String>{
      for (final e in _controllers.entries) e.key: e.value.text.trim(),
    };

    serviceRemoteDataSource.submitApplication(service: _service!, formData: data);

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

    if (_isLoadingProfile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(service.title),
        ),
        body: const Center(child: CircularProgressIndicator()),
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
                decoration: InputDecoration(
                  labelText: field,
                  // Показываем иконку, если поле заполнено из профиля
                  suffixIcon: controller.text.isNotEmpty && _userProfile != null
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                      : null,
                ),
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