import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter5/domain/models/invoice.dart';

class InvoiceLocalDataSource {
  static const String _invoicesKey = 'invoices';

  Future<List<Invoice>> getInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final invoicesJson = prefs.getStringList(_invoicesKey) ?? [];
    return invoicesJson
        .map((invoiceJson) => Invoice.fromJson(json.decode(invoiceJson)))
        .toList();
  }

  Future<void> addInvoice(Invoice invoice) async {
    final prefs = await SharedPreferences.getInstance();
    final invoices = await getInvoices();
    invoices.add(invoice);
    final invoicesJson = invoices.map((invoice) => json.encode(invoice.toJson())).toList();
    await prefs.setStringList(_invoicesKey, invoicesJson);
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    final prefs = await SharedPreferences.getInstance();
    final invoices = await getInvoices();
    final index = invoices.indexWhere((invoice) => invoice.id == updatedInvoice.id);
    if (index != -1) {
      invoices[index] = updatedInvoice;
      final invoicesJson = invoices.map((invoice) => json.encode(invoice.toJson())).toList();
      await prefs.setStringList(_invoicesKey, invoicesJson);
    }
  }

  Future<void> deleteInvoice(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final invoices = await getInvoices();
    invoices.removeWhere((invoice) => invoice.id == id);
    final invoicesJson = invoices.map((invoice) => json.encode(invoice.toJson())).toList();
    await prefs.setStringList(_invoicesKey, invoicesJson);
  }
}
