import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:lines/data/header_json.dart';

final double widthButton = 220;
final double heightButton = 80;

List<int> disablePointsIn180 = [
  10,
  30,
  50,
  70,
  90,
  110,
  130,
  150,
  170,
  190,
  210,
  230,
  250,
  270,
  290,
  310,
  330,
  350
];
List<int> disablePointsIn360 = [
  10,
  30,
  50,
  70,
  90,
  110,
  130,
  150,
  170,
  190,
  210,
  230,
  250,
  270,
  290,
  310,
  330,
  350
];

FocusNode dataFocusNode = FocusNode();

Text title(String text) => Text(
      text,
      style: TextStyle(
        fontSize: 20,
      ),
    );

SizedBox space = SizedBox();

Container textFormField(BuildContext context, String labelText,
        TextEditingController controller, TextInputType keyboardType,
        {bool date = false}) =>
    Container(
      height: 80,
      child: date
          ? TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              focusNode: dataFocusNode,
              controller: controller,
              onTap: () async {
                controller.clear();
                dataFocusNode.unfocus();
                DateTime dateTimePicked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2040),
                );
                if (dateTimePicked != null) {
                  controller.text =
                      dateTimePicked.day.toString().padLeft(2, '0') +
                          '/' +
                          dateTimePicked.month.toString().padLeft(2, '0') +
                          '/' +
                          dateTimePicked.year.toString();
                }
              },
            )
          : TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: keyboardType,
              controller: controller,
              onSaved: (newValue) => controller.text = newValue.toUpperCase(),
            ),
    );

Container containerTitleAndFormFieldMaxSize(Widget child) => Container(
      height: 100,
      width: 350,
      child: Column(
        children: [
          child,
        ],
      ),
    );
Container containerTitleAndFormFieldMedSize(Widget child) => Container(
      height: 100,
      width: 120,
      child: Column(
        children: [
          child,
        ],
      ),
    );
Container containerTitleAndFormFieldMinSize(Widget child) => Container(
      height: 100,
      width: 90,
      child: Column(
        children: [
          child,
        ],
      ),
    );

Container containerAngleText(int angle, double pointSize) => Container(
      padding: EdgeInsets.only(left: 10),
      height: pointSize,
      width: 37,
      color: Colors.white,
      child: Center(
        child: angle >= 0 && angle < 90
            ? RotatedBox(
                quarterTurns: 4,
                child: Text(
                  angle.toString() + 'º',
                  style: TextStyle(
                    fontSize: 3,
                  ),
                ),
              )
            : angle == 90
                ? RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      angle.toString() + 'º',
                      style: TextStyle(
                        fontSize: 3,
                      ),
                    ),
                  )
                : angle > 90 && angle <= 180
                    ? RotatedBox(
                        quarterTurns: 2,
                        child: Text(
                          angle.toString() + 'º',
                          style: TextStyle(
                            fontSize: 3,
                          ),
                        ),
                      )
                    : angle > 180 && angle < 270
                        ? RotatedBox(
                            quarterTurns: 2,
                            child: Text(
                              angle.toString() + 'º',
                              style: TextStyle(
                                fontSize: 3,
                              ),
                            ),
                          )
                        : angle == 270
                            ? RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  angle.toString() + 'º',
                                  style: TextStyle(
                                    fontSize: 3,
                                  ),
                                ),
                              )
                            : RotatedBox(
                                quarterTurns: 4,
                                child: Text(
                                  angle.toString() + 'º',
                                  style: TextStyle(
                                    fontSize: 3,
                                  ),
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
          : (angle == 0 || angle == 90 || angle == 180 || angle == 270)
              ? Center(
                  child: Text(
                    meters.toString(),
                    style: TextStyle(
                        fontSize: maxAngleController.text == '180' ? 8 : 4),
                  ),
                )
              : (angle >= 0 && angle <= 90)
                  ? Center(
                      child: Text(
                        (90 - angle).toString() + '°',
                        style: TextStyle(
                            fontSize: maxAngleController.text == '180' ? 4 : 2),
                      ),
                    )
                  : (angle > 90 && angle <= 180)
                      ? Center(
                          child: Text(
                            (angle - 90).toString() + '°',
                            style: TextStyle(
                                fontSize:
                                    maxAngleController.text == '180' ? 4 : 2),
                          ),
                        )
                      : (angle > 180 && angle <= 270)
                          ? Center(
                              child: Text(
                                (270 - angle).toString() + '°',
                                style: TextStyle(
                                    fontSize: maxAngleController.text == '180'
                                        ? 4
                                        : 2),
                              ),
                            )
                          : Center(
                              child: Text(
                                (angle - 270).toString() + '°',
                                style: TextStyle(
                                    fontSize: maxAngleController.text == '180'
                                        ? 4
                                        : 2),
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
          border: Border.all(
              color: colorBorder,
              width: maxAngleController.text == '180' ? 0.5 : 0.2),
          color: colorContainer,
        ),
        child: child,
      ),
    );

bool noPoint(int meters) => meters == 0 || meters == 1 ? true : false;
bool isAxis(int angle) =>
    angle == 0 || angle == 90 || angle == 180 || angle == 270 ? true : false;
