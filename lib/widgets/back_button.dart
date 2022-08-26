import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleBackButton extends StatelessWidget {
  const CircleBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Ink(
          decoration: const ShapeDecoration(
            color: Color.fromARGB(100, 255, 255, 255),
            shape: CircleBorder(),
          ),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.arrow_back)),
        ));
  }
}
