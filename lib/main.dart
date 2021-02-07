import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lines/view/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return MaterialApp(
      title: 'Teste Sensores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DetailsSensor(),
    );
  }
}
