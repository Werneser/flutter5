import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  @override
  Widget build(BuildContext context) {
    final invoiceService = InvoiceService();
    final invoices = invoiceService.invoices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Квитанции к оплате'),
        automaticallyImplyLeading: false, // Убираем кнопку "назад"
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/invoiceAdd').then((_) {
                setState(() {}); // Обновляем состояние после возвращения
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
              invoiceService.deleteInvoice(invoice.id);
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
                  context.push('/invoiceEdit', extra: invoice).then((_) {
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
