import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';

class InvoiceEditScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceEditScreen({super.key, required this.invoice});

  @override
  State<InvoiceEditScreen> createState() => _InvoiceEditScreenState();
}

class _InvoiceEditScreenState extends State<InvoiceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceNameController;
  late TextEditingController _invoiceNumberController;
  late TextEditingController _amountController;
  late TextEditingController _issueAddressController;
  late TextEditingController _destinationAddressController;
  late InvoiceStatus _status;

  @override
  void initState() {
    super.initState();
    _serviceNameController = TextEditingController(text: widget.invoice.serviceName);
    _invoiceNumberController = TextEditingController(text: widget.invoice.invoiceNumber);
    _amountController = TextEditingController(text: widget.invoice.amount.toString());
    _issueAddressController = TextEditingController(text: widget.invoice.issueAddress);
    _destinationAddressController = TextEditingController(text: widget.invoice.destinationAddress);
    _status = widget.invoice.status;
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedInvoice = Invoice(
        id: widget.invoice.id,
        serviceName: _serviceNameController.text,
        invoiceNumber: _invoiceNumberController.text,
        status: _status,
        amount: double.parse(_amountController.text),
        issueAddress: _issueAddressController.text,
        destinationAddress: _destinationAddressController.text,
      );

      InvoiceService().updateInvoice(updatedInvoice);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать квитанцию'),
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
                value: _status,
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
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
