import 'package:flutter/material.dart';
import 'package:lines/view/header.dart';
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
  List<int> disablePoints = [
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
  double pointSize;
  double lineSize;
  int maxAngle;
  int angleInterval;
  int maxMeters;
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _lineSize();
    maxAngle = 180;
    angleInterval = 10;
    maxMeters = 12;
    _lines();
    _points();
  }

  _lineSize() {
    lineSize = widget.size.height >= widget.size.width
        ? widget.size.height
        : widget.size.width;
    pointSize = lineSize > 1300
        ? 22
        : lineSize <= 1300 && lineSize >= 800
            ? 20
            : 10;
  }

  @override
  Widget build(BuildContext context) {
    if (lineSize == widget.size.height &&
        widget.size.width > widget.size.height) {
      _lineSize();
      setState(() {
        _lines();
        _points(picked: true);
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 2,
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(child: Text('ToDo')),
              decoration: BoxDecoration(color: Colors.red),
            ),
            ListTile(
              title: Text('Gerar PDF'),
              onTap: () => Printing.layoutPdf(
                  format: PdfPageFormat.a4,
                  onLayout: (format) =>
                      generatePdf(format, colorsPoints, maxAngle.toDouble())),
            ),
            ListTile(
              title: Text('Detalhes'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: header(context),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Voltar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: [
            InteractiveViewer(
              maxScale: 20,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: lineSize,
                      width: lineSize,
                      child: Stack(
                        children: [
                          IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () =>
                                  _scaffoldKey.currentState.openDrawer()),
                          for (Widget line in lines.values) line,
                          for (Widget point in points.values) point,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _lines() {
    for (int angle = 0; angle <= maxAngle; angle += angleInterval) {
      lines[angle] = containerGestureDetectorAndWidgetRotate(
          Container(
            height: pointSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: isAxis(angle) ? 2 : 1,
                  width: lineSize / 2 - 10,
                  color: isAxis(angle) ? Colors.black : Colors.grey,
                ),
              ],
            ),
          ),
          angle,
          lineSize);
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
      if (meters == 2 && (disablePoints.contains(angle))) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: pointSize,
                width: (lineSize / 2 - 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: colorsPoints[angle],
                ),
              ),
              containerAngleText(angle, pointSize),
            ],
          ),
          angle,
          lineSize);
    }
  }
}
