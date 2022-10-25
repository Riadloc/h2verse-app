import 'package:flutter/material.dart';

class NumericStepper extends StatelessWidget {
  const NumericStepper(
      {Key? key, required this.count, this.max = 20, required this.onChange})
      : super(key: key);
  final int count;
  final int max;
  final void Function(int count) onChange;

  void onMinus() {
    onChange(count - 1);
  }

  void onPlus() {
    onChange(count + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              constraints: const BoxConstraints(maxHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              onPressed: count > 1 ? onMinus : null,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(
                Icons.remove,
                size: 20,
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                border: Border(
              left: BorderSide(width: 0.5, color: Colors.grey.shade300),
              right: BorderSide(width: 0.5, color: Colors.grey.shade300),
            )),
            child: Text(count.toString()),
          ),
          IconButton(
              constraints: const BoxConstraints(maxHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              onPressed: count < max ? onPlus : null,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(
                Icons.add,
                size: 20,
              ))
        ],
      ),
    );
  }
}
