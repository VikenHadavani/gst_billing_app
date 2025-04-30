import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseService {
  Future<Database> initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'billing_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, gstRate REAL, timestamp TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertInvoice(Product product) async {
    final db = await initDatabase();
    await db.insert(
      'invoices',
      {
        'name': product.name,
        'price': product.price,
        'gstRate': product.gstRate,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getInvoices() async {
    final db = await initDatabase();
    return await db.query('invoices', orderBy: 'timestamp DESC');
  }
}