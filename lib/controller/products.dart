import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lines/model/products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';

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

Future<void> insertProduct(ProductsModel products,
    {bool refreshOnly = false}) async {
  final Database db = await _open();
  try {
    await db.insert(
      'products',
      products.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (!refreshOnly) insertCloudDatabase(products);
  } catch (e) {}
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

Future<void> deleteDatabase() async {
  final Database db = await _open();

  await db.delete('products');
}

Future<void> fetchProducts() async {
  try {
    await Firebase.initializeApp();
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('produtos')
        .doc('sensores')
        .get();
    List<dynamic> produtos = document.get('nomes');
    await deleteDatabase();
    produtos.forEach((element) async {
      await insertProduct(ProductsModel(name: element.toString().toUpperCase()),
          refreshOnly: true);
    });
  } catch (e) {
    return null;
  }
}

Future<void> insertCloudDatabase(ProductsModel product) async {
  try {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('produtos')
        .doc('sensores')
        .get();
    List<dynamic> nomes = document.get('nomes');
    nomes.add(product.name);
    FirebaseFirestore.instance
        .collection('produtos')
        .doc('sensores')
        .set({'nomes': nomes});
  } catch (e) {}
}
