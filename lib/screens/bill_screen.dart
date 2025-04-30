import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gst_provider.dart';
import '../services/database_service.dart';

class BillScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GSTProvider>(context);
    final products = provider.products;
    final totalAmount = provider.totalAmount;

    // Save all products to database
    _saveToDatabase(products);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Invoice header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TATA Retail Solutions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Invoice #: INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Date: ${DateTime.now().toString().substring(0, 16)}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Products list
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Table header
                      Row(
                        children: [
                          Expanded(flex: 3, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('GST %', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('CGST', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('SGST', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      Divider(),
                      // Products
                      Expanded(
                        child: ListView.separated(
                          itemCount: products.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Row(
                              children: [
                                Expanded(flex: 3, child: Text(product.name)),
                                Expanded(flex: 1, child: Text('₹${product.price.toStringAsFixed(2)}')),
                                Expanded(flex: 1, child: Text('${product.gstRate}%')),
                                Expanded(flex: 1, child: Text('₹${product.cgst.toStringAsFixed(2)}')),
                                Expanded(flex: 1, child: Text('₹${product.sgst.toStringAsFixed(2)}')),
                                Expanded(flex: 1, child: Text('₹${product.totalPrice.toStringAsFixed(2)}')),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Summary
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal'),
                        Text('₹${products.fold(0.0, (sum, product) => sum + product.price).toStringAsFixed(2)}'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CGST'),
                        Text('₹${products.fold(0.0, (sum, product) => sum + product.cgst).toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SGST'),
                        Text('₹${products.fold(0.0, (sum, product) => sum + product.sgst).toStringAsFixed(2)}'),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('₹${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice saved successfully!')),
                );
                Navigator.pop(context);
              },
              icon: Icon(Icons.save),
              label: Text('Save Invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveToDatabase(products) async {
    for (var product in products) {
      await _databaseService.insertInvoice(product);
    }
  }
}