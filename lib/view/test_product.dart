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
  double pointSize;
  double containerSize;
  double lineSize;
  int maxAngle;
  int angleInterval;
  int maxMeters;
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    maxAngle = int.parse(maxAngleController.text);
    _containerSize();

    angleInterval = 10;
    maxMeters = maxAngle == 180 ? 12 : 10;
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
            : 7;
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
                          FlatButton(
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
                onTap: () => Printing.layoutPdf(
                    format: PdfPageFormat.a4,
                    name: amostraController.text +
                        '-' +
                        produtoController.text +
                        '-' +
                        dataController.text.replaceAll('/', '-'),
                    onLayout: (format) =>
                        generatePdf(format, colorsPoints, maxAngle.toDouble())),
              ),
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
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      child: RaisedButton(
                        color: Colors.blue[200],
                        child: Text('Reiniciar'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Reiniciar Teste?'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Voltar'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          amostraController.clear();
                                          produtoController.clear();
                                          temperaturaInicialController.clear();
                                          temperaturaFinalController.clear();
                                          umidadeInicialController.clear();
                                          umidadeFinalController.clear();
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
          containerSize);
    }
  }

  _pointClicked(int angle, int meters, Color color) {
    color = color == Colors.white ? Colors.red : Colors.white;
    colorsPoints[angle][meters] = containerPoint(() {
      _pointClicked(angle, meters, color);
    },
        noPoint(meters) ? Colors.transparent : Colors.black,
        noPoint(meters) ? Colors.transparent : color,
        containerRotatedBox(meters, angle),
        pointSize);

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
    colorsPoints[angle] = point;
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
                          children: colorsPoints[angle],
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
                        children: colorsPoints[angle],
                      ),
                    ),
                    containerAngleText(angle, pointSize),
                  ],
                ),
          angle,
          containerSize);
    }
  }
}
