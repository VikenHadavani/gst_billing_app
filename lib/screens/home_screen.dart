import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/gst_provider.dart';
import 'bill_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  double _selectedGSTRate = 18.0; // Default GST rate
  final List<double> _gstRates = [5.0, 12.0, 18.0, 28.0]; // Available GST rates
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TATA Retail - GST Billing App'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_cart),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Product Price (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<double>(
                      decoration: InputDecoration(
                        labelText: 'GST Rate',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.percent),
                      ),
                      value: _selectedGSTRate,
                      items: _gstRates.map((rate) {
                        return DropdownMenuItem<double>(
                          value: rate,
                          child: Text('$rate%'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            _selectedGSTRate = value;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        final String name = _nameController.text;
                        final double price = double.tryParse(_priceController.text) ?? 0.0;
                        
                        if (name.isNotEmpty && price > 0) {
                          final product = Product(
                            name: name, 
                            price: price, 
                            gstRate: _selectedGSTRate
                          );
                          
                          Provider.of<GSTProvider>(context, listen: false).addProduct(product);
                          
                          _nameController.clear();
                          _priceController.clear();
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Product added to bill')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter valid product details')),
                          );
                        }
                      },
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text('Add Product to Bill'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                child: Consumer<GSTProvider>(
                  builder: (context, provider, child) {
                    final products = provider.products;
                    if (products.isEmpty) {
                      return Center(child: Text('No products added yet'));
                    }
                    
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('Price: ₹${product.price.toStringAsFixed(2)} | GST: ${product.gstRate}%'),
                          trailing: Text('₹${product.totalPrice.toStringAsFixed(2)}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final provider = Provider.of<GSTProvider>(context, listen: false);
                      if (provider.products.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please add products first')),
                        );
                        return;
                      }
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BillScreen()),
                      );
                    },
                    icon: Icon(Icons.receipt_long),
                    label: Text('Generate Bill'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<GSTProvider>(context, listen: false).clearProducts();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bill cleared')),
                      );
                    },
                    icon: Icon(Icons.clear_all),
                    label: Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}