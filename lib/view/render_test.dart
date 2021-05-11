import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RenderTest extends StatelessWidget {
  final Map<int, Widget> lines;
  final Map<int, Widget> points;
  final double containerSize;

  const RenderTest(
      {Key key,
      @required this.containerSize,
      @required this.lines,
      @required this.points})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
