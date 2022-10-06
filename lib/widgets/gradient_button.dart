import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';

Widget loadingText = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    )
  ],
);

class GradientButton extends StatelessWidget {
  const GradientButton(
      {Key? key,
      required this.text,
      this.colors,
      this.borderRadius,
      this.style,
      this.loading = false,
      this.onPressed})
      : super(key: key);

  final List<Color>? colors;
  final void Function()? onPressed;
  final double? borderRadius;
  final ButtonStyle? style;
  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (colors == null) {
      return ElevatedButton(
          style: style!.merge(ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              shape: borderRadius != null
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius!))
                  : null)),
          onPressed: onPressed != null
              ? () {
                  if (loading) return;
                  onPressed!();
                }
              : onPressed,
          child: loading ? loadingText : Text(text));
    }
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: colors!,
              stops: const [0, 0.49, 1]),
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
          boxShadow: kCardBoxShadow),
      child: ElevatedButton(
          style: style!.merge(ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          )),
          onPressed: onPressed != null
              ? () {
                  if (loading) return;
                  onPressed!();
                }
              : onPressed,
          child: loading ? loadingText : Text(text)),
    );
  }
}
