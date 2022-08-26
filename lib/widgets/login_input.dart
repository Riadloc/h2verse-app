import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType { text, phone, password, captcha }

// ignore: must_be_immutable
class LoginInput extends StatelessWidget {
  LoginInput(
      {Key? key,
      required this.hintText,
      required this.icon,
      this.obscure = false,
      this.type = InputType.text,
      this.suffix,
      this.controller,
      this.validator})
      : super(key: key);

  final String hintText;
  final InputType type;
  final bool obscure;
  final IconData icon;
  final Widget? suffix;
  final TextEditingController? controller;
  TextInputType keyboardType = TextInputType.text;
  List<TextInputFormatter>? inputFormatters;
  String? Function(String?)? validator;

  final OutlineInputBorder kInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: Color(0xFFECECEC),
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case InputType.phone:
        keyboardType = TextInputType.phone;
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          LengthLimitingTextInputFormatter(11)
        ];
        break;
      case InputType.password:
        keyboardType = TextInputType.visiblePassword;
        break;
      case InputType.captcha:
        keyboardType = TextInputType.number;
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          LengthLimitingTextInputFormatter(4)
        ];
        break;
      default:
    }
    return TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Icon(icon),
          ),
          suffixIcon: suffix,
        ),
        style: const TextStyle(fontSize: 14),
        obscureText: obscure,
        controller: controller,
        inputFormatters: inputFormatters,
        validator: validator,
        keyboardType: keyboardType);
  }
}
