import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/empty_list.webp',
          height: 200,
          fit: BoxFit.cover,
        ),
        Text(
          '没有数据',
          style: TextStyle(color: Colors.grey.shade700),
        )
      ],
    );
  }
}
