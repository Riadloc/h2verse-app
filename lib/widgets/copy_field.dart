import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h2verse_app/utils/toast.dart';

class CopyField extends StatelessWidget {
  const CopyField({super.key, required this.text, this.copyText, this.color});

  final String text;
  final String? copyText;
  final Color? color;

  void onCopy() {
    Clipboard.setData(ClipboardData(text: copyText ?? text));
    Toast.show('复制成功！');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onCopy,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: color ?? Colors.black),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              Icons.copy,
              size: 16,
            )
          ],
        ));
  }
}
