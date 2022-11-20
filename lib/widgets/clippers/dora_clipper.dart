import 'package:flutter/material.dart';

class DoraClipper extends CustomClipper<Path> {
  final double width;
  DoraClipper(this.width);

  @override
  Path getClip(Size size) {
    const double radius = 12;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2 + width / 2, size.height);
    // path.quadraticBezierTo(size.width / 2 + width / 2, size.height,
    //     size.width / 2 + width / 2, size.height - radius);
    path.quadraticBezierTo(size.width / 2 + width / 2, size.height - width / 2,
        size.width / 2, size.height - width / 2);
    path.quadraticBezierTo(size.width / 2 - width / 2, size.height - width / 2,
        size.width / 2 - width / 2, size.height);
    // path.quadraticBezierTo(size.width / 2 - width / 2, size.height,
    //     size.width / 2 - width / 2 - radius, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
