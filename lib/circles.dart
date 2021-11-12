import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Circle extends StatelessWidget {
  final Color color;
  final double diameter;
  final Offset center;

  Circle(
      {required this.color,
      required this.diameter,
      this.center = const Offset(0, 0)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(diameter, diameter),
      painter: CirclePainter(color, center: center),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Offset center;

  CirclePainter(this.color, {required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center ?? Offset(size.width / 2, size.height / 2),
        size.width / 2, Paint()..color = this.color);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
