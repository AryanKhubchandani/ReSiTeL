import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final Color color;
  final double diameter;
  final Offset center;
  final int n;
  final EdgeInsets padding;

  const Circle(
      {Key? key,
      required this.color,
      required this.diameter,
      required this.n,
      required this.padding,
      this.center = const Offset(55.0, 15.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        CustomPaint(
          size: Size(diameter, diameter),
          painter: CirclePainter(color, center: center),
        ),
        Padding(
          padding: padding,
          child: Image.asset(
            "assets/images/hand_gesture$n.png",
            scale: 14,
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Offset center;

  CirclePainter(this.color, {required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      center, //Offset(size.width / 2, size.height / 2),
      size.width,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
