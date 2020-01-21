import 'package:flutter/material.dart';

class BezierPainter extends CustomPainter {
  
  BezierPainter({
    @required List<List<double>> points,
    @required this.lineWidth,
    @required this.color,
  })  : assert(points != null),
        assert(lineWidth != null),
        assert(color != null) {
          this.points = points.expand((l) => l).toList();
        }

  List<double> points;
  double lineWidth;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}