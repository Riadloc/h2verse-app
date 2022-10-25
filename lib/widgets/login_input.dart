import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType {
  text,
  phone,
  password,
  captcha,
  name,
  nickname,
  idNo,
  cardNo,
  email,
  price
}

// ignore: must_be_immutable
class LoginInput extends StatelessWidget {
  LoginInput(
      {Key? key,
      required this.hintText,
      this.icon,
      this.obscure = false,
      this.type = InputType.text,
      this.suffix,
      this.controller,
      this.validator,
      this.onChanged})
      : super(key: key);

  final String hintText;
  final InputType type;
  final bool obscure;
  final IconData? icon;
  final Widget? suffix;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  TextInputType keyboardType = TextInputType.text;
  List<TextInputFormatter>? inputFormatters;

  final OutlineInputBorder kInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
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
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ];
        break;
      case InputType.password:
        keyboardType = TextInputType.visiblePassword;
        break;
      case InputType.captcha:
        keyboardType = TextInputType.number;
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6)
        ];
        break;
      case InputType.nickname:
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z0-9\u4e00-\u9fa5]')),
        ];
        break;
      case InputType.email:
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\.@]')),
        ];
        break;
      case InputType.price:
        keyboardType = TextInputType.number;
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15)
        ];
        break;
      default:
    }
    return TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          prefixIcon: icon != null
              ? Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 20,
                  ),
                )
              : null,
          suffixIcon: suffix,
        ),
        style: const TextStyle(fontSize: 14),
        obscureText: obscure,
        controller: controller,
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType);
  }
}
