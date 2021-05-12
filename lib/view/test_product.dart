import 'package:flutter/material.dart';
import 'package:lines/data/header_json.dart';

import 'package:lines/view/header.dart';
import 'package:lines/view/test_new.dart';
import 'package:lines/widgets/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'pdf.dart';

class TestSensor extends StatefulWidget {
  final Size size;

  const TestSensor({Key key, @required this.size}) : super(key: key);

  @override
  _TestSensorState createState() => _TestSensorState();
}

class _TestSensorState extends State<TestSensor> {
  Map<int, Widget> lines = {};
  Map<int, Widget> points = {};
  Map<int, List<GestureDetector>> colorsPoints = {};
  Map<int, List<GestureDetector>> colorsPointsFrontalTest = {};
  double pointSize;
  double containerSize;
  double lineSize;
  int maxAngle;
  int angleInterval;
  int maxMeters;
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool frontalTest;

  @override
  void initState() {
    super.initState();
    frontalTest = typeOfTestController.text == "Angular" ||
            typeOfTestController.text == "Duplo"
        ? false
        : true;
    maxAngle = int.parse(maxAngleController.text);
    _containerSize();

    angleInterval = 10;
    maxMeters = maxAngle == 180
        ? 12
        : typeOfTestController.text == 'Duplo' &&
                maxAngleController.text == '350'
            ? 7
            : 10;

    _lines();
    _points();
  }

  _containerSize() {
    if (maxAngle == 350) {
      containerSize = widget.size.height >= widget.size.width
          ? widget.size.width
          : widget.size.height;
    } else {
      containerSize = widget.size.height >= widget.size.width
          ? widget.size.height
          : widget.size.width;
    }
    pointSize = containerSize > 1300
        ? 22
        : containerSize <= 1300 && containerSize >= 800
            ? 15
            : maxAngle == 350 && typeOfTestController.text == 'Duplo'?15:7;
    lineSize = containerSize / 2 - 10;
  }

  @override
  Widget build(BuildContext context) {
    if (containerSize == widget.size.height &&
        widget.size.width > widget.size.height) {
      _containerSize();
      setState(() {
        _lines();
        _points(picked: true);
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: Drawer(
          elevation: 2,
          child: ListView(
            children: [
              Container(
                height: 200,
                child: DrawerHeader(
                  child: Text(''),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'images/logo_colorful.jpg',
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Especificações da Amostra',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: header(context),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                  title: Text(
                    'Exportar PDF',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    if (colorsPoints.isEmpty) {
                      frontalTest = false;
                      _points();
                    }
                    if (colorsPointsFrontalTest.isEmpty) {
                      frontalTest = true;
                      _points();
                    }

                    Printing.layoutPdf(
                        format: PdfPageFormat.a4,
                        name: amostraController.text +
                            '-' +
                            produtoController.text +
                            '-' +
                            dataController.text.replaceAll('/', '-') +
                            '-' +
                            typeOfTestController.text,
                        onLayout: (format) => generatePdf(
                            format,
                            colorsPoints,
                            colorsPointsFrontalTest,
                            maxAngle.toDouble(),
                            maxMeters));
                  }),
            ],
          ),
        ),
        body: SafeArea(
          child: InteractiveViewer(
            maxScale: 20,
            child: Stack(
              children: [
                Center(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: containerSize,
                      width: containerSize,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          for (Widget line in lines.values) line,
                          for (Widget point in points.values) point,
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                typeOfTestController.text == "Duplo"
                                    ? "Tipo do Teste: Duplo"
                                    : "Tipo do Teste: Único",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                frontalTest ? "FRONTAL" : "ANGULAR",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (typeOfTestController.text == "Duplo")
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: frontalTest
                                      ? () {
                                          frontalTest = false;
                                          _lines();
                                          if (colorsPoints.isEmpty) {
                                            _points();
                                          } else {
                                            _points(picked: true);
                                          }
                                          setState(() {});
                                        }
                                      : () {
                                          frontalTest = true;

                                          _lines();

                                          if (colorsPointsFrontalTest.isEmpty) {
                                            _points();
                                          } else {
                                            _points(picked: true);
                                          }
                                          setState(() {});
                                        },
                                  child: Text(frontalTest
                                      ? '<- Angular'
                                      : 'Frontal ->')),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                right: 30,
                                left: 30,
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red[200]),
                                ),
                                child: Text('Reiniciar'),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Reiniciar Teste?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Voltar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  amostraController.clear();
                                                  produtoController.clear();
                                                  temperaturaInicialController
                                                      .clear();
                                                  temperaturaFinalController
                                                      .clear();
                                                  umidadeInicialController
                                                      .clear();
                                                  umidadeFinalController
                                                      .clear();
                                                  observacaoController.clear();
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewTest()));
                                                },
                                                child: Text('Confirmar'),
                                              ),
                                            ],
                                          ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _lines() {
    for (int angle = 0; angle <= maxAngle; angle += angleInterval) {
      lines[angle] = containerGestureDetectorAndWidgetRotate(
          maxAngle == 350
              ? Center(
                  child: Container(
                    height: pointSize,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: isAxis(angle) ? 2 : 1,
                          width: lineSize,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: pointSize,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: isAxis(angle) ? 2 : 1,
                        width: lineSize,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
          angle,
          containerSize,
          maxAngle);
    }
  }

  _pointClicked(int angle, int meters, Color color) {
    color = color == Colors.white ? Colors.red : Colors.white;
    if (frontalTest) {
      colorsPointsFrontalTest[angle][meters] = containerPoint(() {
        _pointClicked(angle, meters, color);
      },
          noPoint(meters) ? Colors.transparent : Colors.black,
          noPoint(meters) ? Colors.transparent : color,
          containerRotatedBox(meters, angle),
          pointSize);
    } else {
      colorsPoints[angle][meters] = containerPoint(() {
        _pointClicked(angle, meters, color);
      },
          noPoint(meters) ? Colors.transparent : Colors.black,
          noPoint(meters) ? Colors.transparent : color,
          containerRotatedBox(meters, angle),
          pointSize);
    }

    _points(picked: true);
    setState(() {});
  }

  _buildPoint(
    int angle,
  ) {
    List<GestureDetector> point = [];
    for (int meters = 0; meters <= maxMeters; meters++) {
      if (meters == 2 &&
          maxAngle == 180 &&
          (disablePointsIn180.contains(angle))) {
        point.add(
          containerPoint(
              null, Colors.transparent, Colors.transparent, null, pointSize),
        );
      } else if (meters == 2 &&
          maxAngle == 350 &&
          (disablePointsIn360.contains(angle))) {
        point.add(
          containerPoint(
              null, Colors.transparent, Colors.transparent, null, pointSize),
        );
      } else {
        point.add(
          containerPoint(() {
            _pointClicked(angle, meters, Colors.white);
          },
              noPoint(meters) ? Colors.transparent : Colors.black,
              noPoint(meters) ? Colors.transparent : Colors.white,
              containerRotatedBox(meters, angle),
              pointSize),
        );
      }
    }
    frontalTest
        ? colorsPointsFrontalTest[angle] = point
        : colorsPoints[angle] = point;
  }

  _points({bool picked: false}) {
    for (int angle = 0; angle <= maxAngle; angle += angleInterval) {
      if (!picked) {
        _buildPoint(angle);
      }

      points[angle] = containerGestureDetectorAndWidgetRotate(
          maxAngle == 350
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: pointSize,
                        width: lineSize,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: frontalTest
                              ? colorsPointsFrontalTest[angle]
                              : colorsPoints[angle],
                        ),
                      ),
                      containerAngleText(angle, pointSize),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: pointSize,
                      width: lineSize,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: frontalTest
                            ? colorsPointsFrontalTest[angle]
                            : colorsPoints[angle],
                      ),
                    ),
                    containerAngleText(angle, pointSize),
                  ],
                ),
          angle,
          containerSize,
          maxAngle);
    }
  }
}
