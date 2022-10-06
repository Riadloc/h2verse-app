import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';

class CommonFieldCard extends StatelessWidget {
  const CommonFieldCard(
      {super.key, required this.child, this.marginBottom = 12});

  final Widget child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: EdgeInsets.only(bottom: marginBottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: kCardBoxShadow,
        ),
        child: child);
  }
}
