import 'package:flutter/material.dart';


class DrawerPainter extends CustomPainter {
  final Color color;
  DrawerPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    canvas.drawPath(getShapePath(size.width, size.height), paint);
  }

  // This is the path of the shape we want to draw
  Path getShapePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x / 2, 0)
      ..quadraticBezierTo(x, y / 2, x / 2, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(DrawerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

