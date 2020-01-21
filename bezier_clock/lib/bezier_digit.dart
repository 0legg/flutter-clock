import 'package:bezier_clock/bezier_painter.dart';
import 'package:flutter/material.dart';

class BezierDigit extends StatefulWidget {
  BezierDigit({
    @required this.fromDigit,
    @required this.toDigit,
    @required this.progress,
    @required this.color,
  }): assert(fromDigit != null),
      assert(toDigit != null),
      assert(progress != null),
      assert(progress >= 0.0),
      assert(progress <= 1.0),
      assert(color != null);
  
  final int fromDigit;
  final int toDigit;
  final double progress;
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
          fromDigit: widget.fromDigit,
          toDigit: widget.toDigit,
          progress: widget.progress,
          lineWidth: 10.0,
          color: widget.color,
        ),
      ),  
    );
  }
}
