import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lines/view/products.dart';
import 'package:lines/view/test_new.dart';
import 'package:lines/widgets/widgets.dart';

class DetailsSensor extends StatefulWidget {
  @override
  _DetailsSensorState createState() => _DetailsSensorState();
}

class _DetailsSensorState extends State<DetailsSensor>
    with SingleTickerProviderStateMixin {
  List<bool> pressButton = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Menu',
          style: TextStyle(fontSize: 30, letterSpacing: 5),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            button('Novo', 0, context, NewTest()),
            button('Produtos', 1, context, Products()),
          ],
        ),
      ),
    );
  }

  InkWell button(String title, int index, BuildContext context, Widget route) =>
      InkWell(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: pressButton[index]
                  ? [
                      Colors.blue[400],
                      Colors.blue[600],
                      Colors.blue[400],
                    ]
                  : [
                      Colors.blue[300],
                      Colors.blue[800],
                      Colors.blue[900],
                      Colors.blue[800],
                      Colors.blue[300],
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: pressButton[index]
                ? [
                    BoxShadow(color: Colors.white, offset: Offset(2, 0)),
                    BoxShadow(color: Colors.white, offset: Offset(0, 2)),
                    BoxShadow(color: Colors.black, offset: Offset(-2, 0)),
                    BoxShadow(color: Colors.black, offset: Offset(0, -2)),
                  ]
                : [BoxShadow(color: Colors.black, offset: Offset(0, 3))],
            borderRadius: BorderRadius.circular(10),
          ),
          width: widthButton,
          height: heightButton,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        onTap: () {
          setState(
            () {
              pressButton[index] = !pressButton[index];
            },
          );
          Timer(Duration(milliseconds: 100), () {
            setState(() {
              pressButton[index] = !pressButton[index];
            });
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => route));
          });
        },
      );
}
