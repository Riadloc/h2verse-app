import 'package:flutter/material.dart';
import 'package:h2verse_app/utils/helper.dart';

class Modal extends StatelessWidget {
  const Modal(
      {Key? key,
      required this.title,
      required this.onConfirm,
      this.onCancel,
      this.description,
      this.body,
      this.confirmText = '确认',
      this.cancelText = '取消'})
      : super(key: key);

  final String title;
  final String? description;
  final Widget? body;
  final void Function() onConfirm;
  final void Function()? onCancel;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: getDimensions().width * 0.8,
      // height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          if (description != null)
            Text(
              description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          if (body != null) body!,
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(confirmText),
                ),
              )
            ],
          ),
          onCancel != null
              ? Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text(
                            cancelText,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          )),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    ));
  }
}
