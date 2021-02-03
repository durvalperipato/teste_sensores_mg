import 'package:flutter/material.dart';
import 'package:lines/view/menu.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste Sensores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DetailsSensor(),
    );
  }
}
