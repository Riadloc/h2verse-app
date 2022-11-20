import 'package:flutter/material.dart';

class CyberClipper extends CustomClipper<Path> {
  final double radius;
  CyberClipper(this.radius);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - 80, 0);
    path.lineTo(size.width - 60, 40);
    path.lineTo(size.width - radius, 40);
    path.quadraticBezierTo(size.width, 40, size.width, 40 + radius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, radius);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
