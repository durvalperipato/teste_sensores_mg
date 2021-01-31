import 'package:flutter/material.dart';
import 'dart:math' as math;

final double widthButton = 220;
final double heightButton = 80;

InkWell button(String title, void onTap()) =>
    /* Container(
      width: widthButton,
      height: heightButton,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.grey[300],
          width: 2,
        ),
        gradient: RadialGradient(
          colors: [Colors.blue[100], Colors.blue[50]],
        ),
      ),
      alignment: Alignment.center,
      child:  */
    InkWell(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[300],
              Colors.blue[800],
              Colors.blue[900],
              Colors.blue[800],
              Colors.blue[300],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(0, 4)),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        width: widthButton, // - 40,
        height: heightButton, // - 40,
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
      onTap: onTap,
    );
//);

Container containerAngleText(int angle, double pointSize) => Container(
      padding: EdgeInsets.only(left: 10),
      height: pointSize,
      width: 37,
      color: Colors.white,
      child: Center(
        child: Text(
          angle.toString() + 'º',
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ),
    );

Container containerGestureDetectorAndWidgetRotate(
        Widget child, int angle, double lineSize) =>
    Container(
      height: lineSize -
          10, // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
      width: lineSize -
          10, // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Transform.rotate(
          angle: -angle * (math.pi / 180),
          child: child,
        ),
      ),
    );

RotatedBox containerRotatedBox(int meters, int angle) => RotatedBox(
      quarterTurns: (angle >= 0 && angle <= 80 || angle >= 280 && angle <= 350)
          ? 4
          : (angle == 90 || angle == 270)
              ? 1
              : 2,
      child: noPoint(meters)
          ? null
          : Center(
              child: Text(
                meters.toString(),
                style: TextStyle(fontSize: 7),
              ),
            ),
    );

GestureDetector containerPoint(void Function() onTap, Color colorBorder,
        Color colorContainer, Widget child, double pointSize) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: pointSize,
        width: pointSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorBorder),
          color: colorContainer,
        ),
        child: child,
      ),
    );

bool noPoint(int meters) => meters == 0 || meters == 1 ? true : false;
bool isAxis(int angle) =>
    angle == 0 || angle == 90 || angle == 180 || angle == 270 ? true : false;
