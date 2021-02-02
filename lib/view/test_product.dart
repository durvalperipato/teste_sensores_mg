import 'package:flutter/material.dart';
import 'package:lines/data/header_json.dart';
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
    maxMeters = 12;
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
            : 8;
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
    return Scaffold(
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
                          child: Text('Voltar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                'Gerar PDF',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Printing.layoutPdf(
                  format: PdfPageFormat.a4,
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
              IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
            ],
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
                          color: isAxis(angle) ? Colors.black : Colors.grey,
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
                        color: isAxis(angle) ? Colors.black : Colors.grey,
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
