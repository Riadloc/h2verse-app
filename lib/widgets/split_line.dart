import 'package:flutter/material.dart';

class SplitLine extends StatelessWidget {
  const SplitLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 1,
      child: VerticalDivider(
        color: Colors.grey.shade300,
      ),
    );
  }
}
