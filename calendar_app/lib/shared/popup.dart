import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String title;
  final String? content;
  final String cancelText;
  final String okText;
  final Color cancelColor;
  final Color okColor;
  final Function()? cancel;
  final Function()? ok;
  final bool hideCancel;
  final bool hideOk;

  const Popup({
    Key? key,
    required this.title,
    this.content,
    this.cancelText = "Cancel",
    this.okText = "Okay",
    this.cancelColor = const Color(0xFF4e5ae8),
    this.okColor = const Color(0xFF4e5ae8),
    this.cancel,
    this.ok,
    this.hideCancel = false,
    this.hideOk = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      content: content != null
          ? Text(content!, style: const TextStyle(fontSize: 14))
          : Container(),
      actions: [
        if (!hideCancel)
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => cancelColor.withAlpha(50),
              ),
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => cancelColor,
              ),
            ),
            child: Text(cancelText),
            onPressed: cancel,
          ),
        if (!hideOk)
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => okColor.withAlpha(50),
              ),
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => okColor,
              ),
            ),
            child: Text(okText),
            onPressed: ok,
          ),
      ],
    );
  }
}
