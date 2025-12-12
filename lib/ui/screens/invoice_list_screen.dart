import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/invoice_remote_datasource.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/models/invoice.dart';
import '../../injection_container.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState(GetIt.I<GetInvoicesUseCase>());
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final GetInvoicesUseCase getInvoicesUseCase;

  _InvoiceListScreenState(this.getInvoicesUseCase);

  @override
  Widget build(BuildContext context) {
    final invoices = getInvoicesUseCase.execute();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Квитанции к оплате'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).push('/invoiceAdd').then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return Dismissible(
            key: Key(invoice.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              getIt<InvoiceRemoteDataSource>().deleteInvoice(invoice.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Квитанция ${invoice.invoiceNumber} удалена')),
              );
            },
            child: Card(
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.status.toString().split('.').last,
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
                  GoRouter.of(context).push('/invoiceEdit', extra: invoice).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
