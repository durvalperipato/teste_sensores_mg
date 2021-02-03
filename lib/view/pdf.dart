import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lines/data/header_json.dart';
import 'package:lines/widgets/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final double widthTextAngle = 20;

final double lineSize = 577;

double maxAngle;

final double pointSize = 10;

Map<int, pw.Widget> lines = {};
Map<int, pw.Widget> points = {};
Map<int, List<pw.Widget>> colorsPointsPdf = {};

Future<Uint8List> generatePdf(PdfPageFormat format,
    Map<int, List<GestureDetector>> colorsPoints, double angle) async {
  maxAngle = angle;
  lines.clear();
  points.clear();
  colorsPointsPdf.clear();

  Map<int, List<BoxDecoration>> colors = {};
  colorsPoints.forEach((key, value) {
    List<BoxDecoration> color = [];
    value.forEach((element) {
      Container container = element.child;
      BoxDecoration boxDecoration = container.decoration;
      color.add(boxDecoration);
    });
    colors[key] = color;
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
              children: [
                headerPdf(),
                result(),
              ],
            ),
          ),
        );
      },
    ),
  );

  return pdf.save();
}

headerPdf() {
  return pw.Container(
    padding: pw.EdgeInsets.all(10),
    child: pw.Column(
      children: [
        pw.Container(
          color: PdfColors.grey,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                    height: 25,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Amostra'))),
              ),
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                    height: 25,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Produto'))),
              ),
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                    height: 25,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Local'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: 25,
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
                height: 25,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(amostraController.text),
                ),
              ),
            ),
            pw.Expanded(
              flex: 5,
              child: pw.Container(
                height: 25,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(produtoController.text),
                ),
              ),
            ),
            pw.Expanded(
              flex: 5,
              child: pw.Container(
                height: 25,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(localController.text),
                ),
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Container(
                height: 25,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Center(
                  child: pw.Text(dataController.text),
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
                    height: 25,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Sensibilidade'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: 25,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Tensão'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: 25,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Center(child: pw.Text('Temperatura'))),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                    height: 25,
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
                        height: 25,
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
                        height: 25,
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
                        height: 25,
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
                        height: 25,
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
                        height: 25,
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
                        height: 25,
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
                        height: 25,
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
                        height: 25,
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
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(sensibilidadeMinimaController.text),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(sensibilidadeMaximaController.text),
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
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(tensao127Controller.text),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(tensao220Controller.text),
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
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child:
                            pw.Text(temperaturaInicialController.text + ' °C'),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(temperaturaFinalController.text + ' °C'),
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
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(umidadeInicialController.text + ' %RH'),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text(umidadeFinalController.text + ' %RH'),
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

result() {
  return pw.Stack(
    children: [
      for (pw.Widget line in lines.values) line,
      for (pw.Widget point in points.values) point,
    ],
  );
}

_lines() {
  for (int angle = 0; angle <= maxAngle; angle += 10) {
    lines[angle] = pw.Container(
      height: lineSize -
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
                height:
                    angle == 0 || angle == 90 || angle == 180 || angle == 270
                        ? 2
                        : 1,
                width: (lineSize / 2 - 10),
                color: angle == 0 || angle == 90 || angle == 180 || angle == 270
                    ? PdfColors.black
                    : PdfColors.grey,
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
      height: lineSize -
          10, // garantir que a area inteira da tela utilize o GestureDetector ao rotacionar, ou seja, o Pai tem que ser maior que o Filho
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
                : disablePointsIn360.contains(
                    angle)) /* (angle == 10 ||
                angle == 30 ||
                angle == 50 ||
                angle == 70 ||
                angle == 90 ||
                angle == 110 ||
                angle == 130 ||
                angle == 150 ||
                angle == 170 ||
                angle == 190 ||
                angle == 210 ||
                angle == 230 ||
                angle == 250 ||
                angle == 270 ||
                angle == 290 ||
                angle == 310 ||
                angle == 330 ||
                angle == 350) */
        ||
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
            border: pw.Border.all(color: PdfColors.black),
            color: colors[angle].elementAt(meters).color == Colors.white
                ? PdfColors.white
                : PdfColors.red,
            //PdfColors.white,
          ),
          child: (angle >= 0 && angle <= 80 || angle >= 280 && angle <= 350) &&
                  (meters != 0 && meters != 1)
              ? //pw.RotatedBox(
              //quarterTurns: 4,
              /* child: */ pw.Center(
                  child: pw.Text(
                    meters.toString(),
                    style: pw.TextStyle(fontSize: 5),
                  ),
                )
              //)
              : (angle == 90 || angle == 270) &&
                      (meters != 0 &&
                          meters != 1) /* meters != 0 && meters != 1 */
                  ? /* RotatedBox(
                              quarterTurns: 1,
                              child:  */
                  pw.Center(
                      child: pw.Text(
                        meters.toString(),
                        style: pw.TextStyle(fontSize: 5),
                      ),
                      //),
                    )
                  : meters != 0 && meters != 1
                      ? /* RotatedBox(
                                  quarterTurns: 2,
                                  child:  */
                      pw.Center(
                          child: pw.Text(
                            meters.toString(),
                            style: pw.TextStyle(fontSize: 5),
                          ),
                          //  ),
                        )
                      : null,
        ),
      );
    }
  }
  colorsPointsPdf[angle] = point;
}
