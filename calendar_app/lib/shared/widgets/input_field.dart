import 'package:calendar_app/shared/themes.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final Function()? onClick;
  final bool isMultiline;

  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.onClick,
      this.isMultiline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: titleStyle,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: isMultiline ? null : 52,
              constraints: const BoxConstraints(minHeight: 52),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType:
                          isMultiline ? TextInputType.multiline : null,
                      maxLines: isMultiline ? null : 1,
                      onTap: onClick,
                      readOnly: widget != null,
                      autofocus: false,
                      controller: controller,
                      style: subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget == null ? Container() : Container(child: widget)
                ],
              ),
            ),
            onTap: onClick,
          ),
        ],
      ),
    );
  }
}
