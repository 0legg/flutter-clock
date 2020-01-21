import 'package:bezier_clock/bezier_data.dart';
import 'package:bezier_clock/bezier_painter.dart';
import 'package:flutter/material.dart';

class BezierDigit extends StatefulWidget {
  BezierDigit({
    @required this.digit,
    @required this.color,
  }): assert(digit != null),
      assert(color != null);
  
  final int digit;
  final Color color;
  
  @override
  State<StatefulWidget> createState() => _BezierDigitState();
}

class _BezierDigitState extends State<BezierDigit> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 500,
      child: CustomPaint( 
        painter: BezierPainter(
          points: BezierData[widget.digit],
          lineWidth: 10.0,
          color: widget.color,
        ),
      ),  
    );
  }
}
