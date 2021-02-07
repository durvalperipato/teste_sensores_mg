import 'package:lines/model/products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> _open() async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE products(name TEXT)",
      );
    },
    version: 1,
  );
  return database;
}

Future<void> insertProduct(ProductsModel products) async {
  final Database db = await _open();
  await db.insert(
    'products',
    products.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<ProductsModel>> getProducts() async {
  final Database db = await _open();

  final List<Map<String, dynamic>> maps = await db.query('products');

  return List.generate(maps.length, (i) {
    return ProductsModel(
      name: maps[i]['name'],
    );
  });
}

Future<void> deleteProduct(ProductsModel product) async {
  final Database db = await _open();

  await db.delete('products', where: 'name = ?', whereArgs: [product.name]);
}
