import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CounterDownTextButton extends StatefulWidget {
  const CounterDownTextButton(
      {Key? key, this.onPressed, this.onFinished, this.duration = 0})
      : super(key: key);

  final void Function()? onPressed;
  final void Function()? onFinished;
  final int duration;

  @override
  State<CounterDownTextButton> createState() => _CounterDownTextButtonState();
}

class _CounterDownTextButtonState extends State<CounterDownTextButton> {
  final int interval = 1000;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => widget.duration == 0 ? widget.onPressed!() : null,
        style: TextButton.styleFrom(
            minimumSize: const Size(30, 20),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.only(right: 10)),
        child: widget.duration == 0
            ? const Text('发送验证码')
            : Countdown(
                seconds: widget.duration,
                build: (BuildContext context, double time) =>
                    Text('${time.toInt()}秒后重发'),
                interval: Duration(milliseconds: interval),
                onFinished: () {
                  widget.onFinished!();
                },
              ));
  }
}
