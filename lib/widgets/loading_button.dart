import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton(
      {super.key,
      required this.loading,
      required this.onPressed,
      required this.child,
      this.style});

  final bool loading;
  final void Function()? onPressed;
  final ButtonStyle? style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: style,
        onPressed: onPressed != null
            ? () {
                if (loading) return;
                onPressed!();
              }
            : onPressed,
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              )
            : child);
  }
}
