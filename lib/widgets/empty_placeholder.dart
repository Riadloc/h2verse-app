import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({Key? key, this.title = '没有数据'}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/empty_list.png',
          height: 200,
          fit: BoxFit.cover,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade700),
        )
      ],
    );
  }
}
