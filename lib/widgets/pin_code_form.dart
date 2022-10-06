import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:pinput/pinput.dart';

class PinCodeForm extends StatefulWidget {
  const PinCodeForm({Key? key, required this.onComplete}) : super(key: key);
  final void Function(String pin) onComplete;

  @override
  State<PinCodeForm> createState() => _PinCodeFormState();
}

class _PinCodeFormState extends State<PinCodeForm> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int length = 6;
    const borderColor = Colors.blue;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 46,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return SizedBox(
      height: 90,
      child: Pinput(
          length: length,
          controller: controller,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            if (!simplePswList.contains(pin)) {
              widget.onComplete(pin);
            }
          },
          focusedPinTheme: defaultPinTheme.copyWith(
            height: 52,
            width: 50,
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: borderColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: errorColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (pin) {
            if (simplePswList.contains(pin)) {
              return '密码太过简单';
            }
            return null;
          }),
    );
  }
}
