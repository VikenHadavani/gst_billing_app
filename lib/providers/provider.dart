import 'package:flutter/material.dart';
import '../models/product.dart';

class GSTProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  double get totalAmount => _products.fold(0, (sum, product) => sum + product.totalPrice);
  
  void clearProducts() {
    _products = [];
    notifyListeners();
  }
}