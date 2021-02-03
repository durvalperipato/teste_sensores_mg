import 'package:lines/model/products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> _open() async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT)",
      );
    },
    version: 1,
  );
  return database;
}

Future<void> insertProduct(ProductsModel products) async {
  // Get a reference to the database.
  final Database db = await _open();
  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'products',
    products.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<ProductsModel>> getProducts() async {
  // Get a reference to the database.
  final Database db = await _open();

  // Query the table for all The Products.
  final List<Map<String, dynamic>> maps = await db.query('products');

  // Convert the List<Map<String, dynamic> into a List<Products>.
  return List.generate(maps.length, (i) {
    return ProductsModel(
      name: maps[i]['name'],
    );
  });
}

Future<void> deleteProduct(ProductsModel product) async {
  final Database db = await _open();
  print('Deletando');
  await db.delete('products', where: 'name = ?', whereArgs: [product.name]);
  print('Deletei');
}
