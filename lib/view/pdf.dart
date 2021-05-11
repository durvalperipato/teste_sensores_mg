import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lines/data/header_json.dart';
import 'package:lines/widgets/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final double widthTextAngle = 20;
final double heigthContainerTextHeader = 15;

final double lineSize = 577;

double maxAngle;

final double pointSize = 10;

var imageFrontal;
var imageAngular;

Map<int, pw.Widget> lines = {};
Map<int, pw.Widget> points = {};
Map<int, List<BoxDecoration>> colors = {};
Map<int, List<BoxDecoration>> colorsFrontalTest = {};
Map<int, List<pw.Widget>> colorsPointsPdf = {};
Map<int, List<pw.Widget>> colorsPointsFrontalTestPdf = {};

Future<Uint8List> generatePdf(
    PdfPageFormat format,
    Map<int, List<GestureDetector>> colorsPoints,
    Map<int, List<GestureDetector>> colorsPointsFrontalTest,
    double angle) async {
  maxAngle = angle;
  lines.clear();
  points.clear();
  colorsPointsPdf.clear();
  colorsPointsFrontalTestPdf.clear();
  colors.clear();
  colorsFrontalTest.clear();
  Uint8List data =
      (await rootBundle.load('images/seta_frontal.png')).buffer.asUint8List();
  imageFrontal = pw.MemoryImage(
    data,
  );

  Uint8List data2 =
      (await rootBundle.load('images/seta_angular.png')).buffer.asUint8List();
  imageAngular = pw.MemoryImage(
    data2,
  );
  colorsPoints.forEach((key, value) {
    List<BoxDecoration> color = [];
    value.forEach((element) {
      Container container = element.child;
      BoxDecoration boxDecoration = container.decoration;
      color.add(boxDecoration);
    });
    colors[key] = color;
  });
  colorsPointsFrontalTest.forEach((key, value) {
    List<BoxDecoration> color = [];
    value.forEach((element) {
      Container container = element.child;
      BoxDecoration boxDecoration = container.decoration;
      color.add(boxDecoration);
    });
    colorsFrontalTest[key] = color;
  });

  _lines();
  _points(colors);

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      pageFormat: format,
      build: (context) {
        return pw.Center(
          child: pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                headerPdf(),
                result(),
                if (typeOfTestController.text == 'Duplo') drawDivider(),
                if (typeOfTestController.text == 'Duplo')
                  result(doubleTest: true),
                bottomPdf(),
              ],
            ),
          ),
        );
      },
    ),
  );

  return pdf.save();
}

imageTypeOfTest(var image) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 3),
    child: pw.Image(image, height: 70, fit: pw.BoxFit.fitWidth),
  );
}

bottomPdf() {
  return pw.Container(
    padding: pw.EdgeInsets.all(5),
    child: pw.Column(
      children: [
        pw.Container(
          height: 25,
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
              color: PdfColors.grey),
          child: pw.Center(
            child: pw.Text('Observação'),
          ),
        ),
        pw.Container(
          height: heigthContainerTextHeader,
          decoration:
              pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
          child: pw.Center(
            child: pw.Text(observacaoController.text.toUpperCase()),
          ),
        ),
      ],
    ),
  );
}

headerPdf() {
  return pw.Container(
    padding: pw.EdgeInsets.all(4),
    child: pw.Column(
      children: [
        pw.Align(
          alignment: pw.Alignment.topRight,
          child: pw.Container(
            child: pw.Column(
              children: [
                pw.Container(
                  height: 15,
                  width: 100,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                    color: PdfColors.grey,
                  ),
                  child: pw.Center(
                    child: pw.Text('RIA'),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 5),
                  height: 15,
                  width: 100,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                    color: PdfColors.white,
                  ),
                  child: pw.Center(
                    child: pw.Text(riaController.text.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
        pw.Container(
          color: PdfColors.grey,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Amostra'))),
              ),
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Produto'))),
              ),
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Local'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Data'))),
              ),
            ],
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                height: heigthContainerTextHeader,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(amostraController.text.toUpperCase()),
                ),
              ),
            ),
            pw.Expanded(
              flex: 5,
              child: pw.Container(
                height: heigthContainerTextHeader,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(produtoController.text.toUpperCase(),
                      style: pw.TextStyle(
                          fontSize:
                              produtoController.text.length > 20 ? 07 : 12)),
                ),
              ),
            ),
            pw.Expanded(
              flex: 5,
              child: pw.Container(
                height: heigthContainerTextHeader,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(localController.text.toUpperCase()),
                ),
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Container(
                height: heigthContainerTextHeader,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(dataController.text.toUpperCase()),
                ),
              ),
            ),
          ],
        ),
        pw.Container(
          color: PdfColors.grey,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Sensibilidade'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Tensão'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Temperatura'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: heigthContainerTextHeader,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Umidade'))),
              ),
            ],
          ),
        ),
        pw.Container(
          color: PdfColors.grey300,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Min'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Med'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Max'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('127'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('220'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Inicial'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Final'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Inicial'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: heigthContainerTextHeader,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Center(
                          child: pw.Text('Final'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            sensibilidadeMinimaController.text.toUpperCase()),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            sensibilidadeMediaController.text.toUpperCase()),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            sensibilidadeMaximaController.text.toUpperCase()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(tensao127Controller.text.toUpperCase()),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(tensao220Controller.text.toUpperCase()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            temperaturaInicialController.text.toUpperCase() +
                                ' °C'),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            temperaturaFinalController.text.toUpperCase() +
                                ' °C'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            umidadeInicialController.text.toUpperCase() + ' %'),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: heigthContainerTextHeader,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                            umidadeFinalController.text.toUpperCase() + ' %'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

drawDivider() {
  return pw.Container(
      margin: pw.EdgeInsets.only(top: 1),
      height: 1,
      color: PdfColors.black,
      width: lineSize);
}

result({bool doubleTest = false}) {
  if (doubleTest) {
    _points(colorsFrontalTest);
  }
  return pw.Container(
    height: maxAngle == 180 ? lineSize / 2 + 20 : lineSize + 20,
    width: lineSize - 10,
    child: pw.Stack(
      children: [
        if (typeOfTestController.text == 'Angular' ||
            typeOfTestController.text == 'Duplo')
          if (doubleTest)
            imageTypeOfTest(imageFrontal)
          else
            imageTypeOfTest(imageAngular),
        if (typeOfTestController.text == 'Frontal')
          imageTypeOfTest(imageFrontal),
        for (pw.Widget line in lines.values)
          pw.Positioned(bottom: 0, left: 0, right: 0, child: line),
        for (pw.Widget point in points.values)
          pw.Positioned(bottom: 0, left: 0, right: 0, child: point),
      ],
    ),
  );
}

_lines() {
  for (int angle = 0; angle <= maxAngle; angle += 10) {
    lines[angle] = pw.Container(
      height: maxAngle == 180
          ? null
          : lineSize -
              10, // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
      width: lineSize -
          10, // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
      child: pw.Transform.rotate(
        angle: angle * (math.pi / 180),
        child: pw.Container(
          height: pointSize,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Container(
                height: isAxis(angle) ? 2 : 1,
                width: (lineSize / 2) - 10,
                color: PdfColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_points(Map<int, List<BoxDecoration>> colors) {
  for (int angle = 0; angle <= maxAngle; angle += 10) {
    _buildPoint(angle, colors);

    points[angle] = pw.Container(
      height: maxAngle == 180 ? null : lineSize - 10,
      // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
      width: lineSize -
          10, // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
      child: pw.Transform.rotate(
        angle: angle * (math.pi / 180),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              height: pointSize,
              width: (lineSize / 2 - 10) - widthTextAngle,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: colorsPointsPdf[angle],
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(left: 1),
              height: pointSize,
              width: widthTextAngle,
              color: PdfColors.white,
              child: pw.Center(
                child: pw.Text(
                  angle.toString() + 'º',
                  style: pw.TextStyle(
                    fontSize: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_buildPoint(int angle, Map<int, List<BoxDecoration>> colors) {
  List<pw.Widget> point = [];
  int maxMeters = maxAngle == 180 ? 12 : 10;
  for (int meters = 0; meters <= maxMeters; meters++) {
    if (meters == 2 &&
            (maxAngle == 180
                ? disablePointsIn180.contains(angle)
                : disablePointsIn360.contains(angle)) ||
        meters == 0 ||
        meters == 1) {
      point.add(
        pw.Container(
          height: pointSize,
          width: pointSize,
        ),
      );
    } else {
      point.add(
        pw.Container(
          height: pointSize,
          width: pointSize,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            border: pw.Border.all(
                color: colors[angle].elementAt(meters).color == Colors.white
                    ? PdfColors.grey
                    : PdfColors.black),
            color: colors[angle].elementAt(meters).color == Colors.white
                ? PdfColors.white
                : PdfColors.red,
          ),
          child: (angle >= 0 && angle <= 80 || angle >= 280 && angle <= 350) &&
                  (meters != 0 && meters != 1)
              ? pw.Center(
                  child: pw.Text(
                    meters.toString(),
                    style: pw.TextStyle(
                        fontSize: 5,
                        color: colors[angle].elementAt(meters).color ==
                                Colors.white
                            ? PdfColors.grey
                            : PdfColors.black),
                  ),
                )
              : (angle == 90 || angle == 270) && (meters != 0 && meters != 1)
                  ? pw.Center(
                      child: pw.Text(
                        meters.toString(),
                        style: pw.TextStyle(
                            fontSize: 5,
                            color: colors[angle].elementAt(meters).color ==
                                    Colors.white
                                ? PdfColors.grey
                                : PdfColors.black),
                      ),
                    )
                  : meters != 0 && meters != 1
                      ? pw.Center(
                          child: pw.Text(
                            meters.toString(),
                            style: pw.TextStyle(
                                fontSize: 5,
                                color: colors[angle].elementAt(meters).color ==
                                        Colors.white
                                    ? PdfColors.grey
                                    : PdfColors.black),
                          ),
                        )
                      : null,
        ),
      );
    }
  }
  colorsPointsPdf[angle] = point;
}
