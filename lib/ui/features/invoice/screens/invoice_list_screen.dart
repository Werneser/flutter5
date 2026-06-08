import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';
import 'package:flutter5/domain/usecases/get_invoices_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'invoice_detail_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final GetInvoicesUseCase getInvoicesUseCase = GetIt.I<GetInvoicesUseCase>();
  late Future<List<Invoice>> _invoicesFuture;
  bool _isEmployee = false;

  @override
  void initState() {
    super.initState();
    _invoicesFuture = getInvoicesUseCase.execute();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final authDataSource = GetIt.I<AuthRemoteDataSource>();
    final isEmployee = await authDataSource.isEmployee();
    if (mounted) {
      setState(() {
        _isEmployee = isEmployee;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Квитанции к оплате'),
        automaticallyImplyLeading: false,
        actions: [
          if (_isEmployee)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                GoRouter.of(context).push('/invoiceAdd').then((_) {
                  setState(() {
                    _invoicesFuture = getInvoicesUseCase.execute();
                  });
                });
              },
            ),
        ],
      ),
      body: FutureBuilder<List<Invoice>>(
        future: _invoicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет квитанций'));
          } else {
            final invoices = snapshot.data!;
            return ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(invoice.serviceName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Номер: ${invoice.invoiceNumber}'),
                        Text('Адрес: ${invoice.destinationAddress}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${invoice.amount} ₽',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invoice.status.name,
                          style: TextStyle(
                            color: invoice.status == InvoiceStatus.overdue
                                ? Colors.red
                                : invoice.status == InvoiceStatus.paid
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InvoiceDetailScreen(invoice: invoice),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}