import 'package:flutter/material.dart';
import 'package:lines/details_test.dart';

void main() {
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.size}) : super(key: key);

  final Size size;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
