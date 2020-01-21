import 'dart:ui' show lerpDouble;

import 'package:bezier_clock/bezier_data.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class BezierPainter extends CustomPainter {
  
  BezierPainter({
    @required this.fromDigit,
    @required this.toDigit,
    @required this.progress,
    @required this.lineWidth,
    @required this.color,
  }): assert(fromDigit != null),
      assert(toDigit != null),
      assert(progress != null),
      assert(progress >= 0.0),
      assert(progress <= 1.0),
      assert(lineWidth != null),
      assert(color != null);

  int fromDigit;
  int toDigit;
  double progress;
  double lineWidth;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fromPoints = BezierData[fromDigit].expand((it) => it).toList();
    final toPoints = BezierData[toDigit].expand((it) => it).toList();

    final points = zip([fromPoints, toPoints])
        .map((pair) => lerpDouble(pair[0], pair[1], progress))
        .toList();
    
    final path = Path();
    var i = 0;
    path.moveTo(points[i++], points[i++]);
    for (; i < points.length;) {
      path.cubicTo(points[i++], points[i++], points[i++], points[i++], points[i++], points[i++]);
    }

    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BezierPainter oldDelegate) {
    return fromDigit != oldDelegate.fromDigit || toDigit != oldDelegate.toDigit || progress != oldDelegate.progress;
  }
}