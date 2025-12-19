import 'package:flutter/material.dart';
import 'package:flutter5/domain/models/invoice.dart';
import 'package:flutter5/domain/usecases/add_invoices_usecase.dart';
import 'package:flutter5/domain/usecases/get_invoices_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

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

  _InvoiceAddScreenState(this.addInvoiceUseCase);

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
      final invoice = Invoice(
        id: const Uuid().v4(),
        serviceName: _serviceNameController.text,
        invoiceNumber: _invoiceNumberController.text,
        status: _status,
        amount: double.parse(_amountController.text),
        issueAddress: _issueAddressController.text,
        destinationAddress: _destinationAddressController.text,
      );

      await addInvoiceUseCase.execute(invoice);
      if (mounted) GoRouter.of(context).pop();
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
              TextFormField(
                controller: _serviceNameController,
                decoration: const InputDecoration(labelText: 'Название услуги'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название услуги';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _invoiceNumberController,
                decoration: const InputDecoration(labelText: 'Номер квитанции'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите номер квитанции';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Сумма к оплате'),
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
              TextFormField(
                controller: _issueAddressController,
                decoration: const InputDecoration(labelText: 'Адрес выдачи квитанции'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите адрес выдачи';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationAddressController,
                decoration: const InputDecoration(labelText: 'Адрес назначения квитанции'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите адрес назначения';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<InvoiceStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Статус'),
                items: InvoiceStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.toString().split('.').last,
                    ),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
