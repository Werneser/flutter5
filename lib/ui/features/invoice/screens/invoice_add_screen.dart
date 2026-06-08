import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';
import 'package:flutter5/domain/usecases/add_invoices_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

import '../../../../data/datasources/Remote/invoice_remote_datasource.dart';

class InvoiceAddScreen extends StatefulWidget {
  const InvoiceAddScreen({super.key});

  @override
  State<InvoiceAddScreen> createState() => _InvoiceAddScreenState(GetIt.I<AddInvoiceUseCase>());
}

class _InvoiceAddScreenState extends State<InvoiceAddScreen> {
  final AddInvoiceUseCase addInvoiceUseCase;
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _invoiceNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _issueAddressController = TextEditingController();
  final _destinationAddressController = TextEditingController();
  InvoiceStatus _status = InvoiceStatus.unpaid;

  List<Map<String, String>> _users = [];
  String? _selectedUserLogin;
  bool _isLoadingUsers = true;

  _InvoiceAddScreenState(this.addInvoiceUseCase);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final authDataSource = GetIt.I<AuthRemoteDataSource>();
      final token = await authDataSource.getToken();

      if (token == null) {
        setState(() => _isLoadingUsers = false);
        return;
      }

      final dio = GetIt.I<Dio>();
      final response = await dio.get(
        '/users',
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = response.data;
        if (mounted) {
          setState(() {
            _users = users.map((u) => {
              'login': u['login'] as String,
              'name': u['name'] as String,
            }).toList();
            _isLoadingUsers = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingUsers = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки пользователей: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _invoiceNumberController.dispose();
    _amountController.dispose();
    _issueAddressController.dispose();
    _destinationAddressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUserLogin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите пользователя')),
        );
        return;
      }

      final invoice = Invoice(
        id: const Uuid().v4(),
        serviceName: _serviceNameController.text,
        invoiceNumber: _invoiceNumberController.text,
        status: _status,
        amount: double.parse(_amountController.text),
        issueAddress: _issueAddressController.text,
        destinationAddress: _destinationAddressController.text,
      );

      try {
        final invoiceRemoteDataSource = GetIt.I<InvoiceRemoteDataSource>();
        await invoiceRemoteDataSource.addInvoice(invoice, userName: _selectedUserLogin);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Квитанция успешно добавлена')),
          );
          GoRouter.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить квитанцию'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Выпадающий список пользователей
              _isLoadingUsers
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : DropdownButtonFormField<String>(
                value: _selectedUserLogin,
                decoration: const InputDecoration(
                  labelText: 'Пользователь',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                hint: const Text('Выберите пользователя'),
                items: _users.map((user) {
                  return DropdownMenuItem<String>(
                    value: user['login'],
                    child: Text(
                      '${user['name']} (${user['login']})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUserLogin = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите пользователя';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _serviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Название услуги',
                  prefixIcon: Icon(Icons.miscellaneous_services),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название услуги';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _invoiceNumberController,
                decoration: const InputDecoration(
                  labelText: 'Номер квитанции',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите номер квитанции';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Сумма к оплате',
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите сумму';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректную сумму';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueAddressController,
                decoration: const InputDecoration(
                  labelText: 'Адрес выдачи квитанции',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите адрес выдачи';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationAddressController,
                decoration: const InputDecoration(
                  labelText: 'Адрес назначения квитанции',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите адрес назначения';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<InvoiceStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Статус',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                items: InvoiceStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Добавить', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}