import 'package:flutter/material.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(
      size.width / 2, // X control point (horizontal center)
      size.height, // Y control point (increase this value to make the curve higher)
      size.width, // End X point
      size.height - 70, // End Y point
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
