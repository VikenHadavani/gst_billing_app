class Product {
  final String name;
  final double price;
  final double gstRate;

  Product({required this.name, required this.price, required this.gstRate});

  double get cgst => (price * gstRate / 100) / 2;
  double get sgst => (price * gstRate / 100) / 2;
  double get totalPrice => price + cgst + sgst;
}