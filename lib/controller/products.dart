import 'package:lines/model/products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> _open() async {
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'database.db'),
    // When the database is first created, create a table to store products.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.

      db.execute(
        "CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT)",
      );
    },

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  return database;
}

Future<void> insertProduct(Products products) async {
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

Future<List<Products>> getProducts() async {
  // Get a reference to the database.
  final Database db = await _open();

  // Query the table for all The Products.
  final List<Map<String, dynamic>> maps = await db.query('products');

  // Convert the List<Map<String, dynamic> into a List<Products>.
  return List.generate(maps.length, (i) {
    return Products(
      id: maps[i]['id'],
      name: maps[i]['name'],
    );
  });
}
