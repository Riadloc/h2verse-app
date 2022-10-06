import 'package:flutter/material.dart';

class UpgradeModal extends StatelessWidget {
  const UpgradeModal(
      {Key? key,
      required this.title,
      required this.onConfirm,
      this.onCancel,
      this.description,
      this.confirmText = '立即更新',
      this.cancelText = '稍后更新'})
      : super(key: key);

  final String title;
  final String? description;
  final void Function() onConfirm;
  final void Function()? onCancel;
  final String confirmText;
  final String cancelText;

  List<Widget> buildButtons() {
    List<Widget> buttons = [];
    if (onCancel != null) {
      buttons.add(Expanded(
          child: TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(
                cancelText,
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ))));
      buttons.add(SizedBox(
        height: 30,
        width: 1,
        child: VerticalDivider(
          color: Colors.grey.shade300,
        ),
      ));
    }
    buttons.add(Expanded(
        child: TextButton(
      onPressed: onConfirm,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: Text(confirmText),
    )));
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      // height: 180,
      padding: const EdgeInsets.only(top: 16),
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
            height: 8,
          ),
          if (description != null)
            Text(
              description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          const SizedBox(
            height: 12,
          ),
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildButtons(),
          ),
        ],
      ),
    ));
  }
}
