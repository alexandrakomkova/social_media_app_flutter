import 'package:flutter/material.dart';

class CustomAlertDialog extends AlertDialog {
  final String dialogTitle;
  final String dialogContent;
  final String rightButtonTitle;
  final void Function()? onRightPressed;
  final String leftButtonTitle;
  final void Function()? onLeftPressed;

  const CustomAlertDialog({
    super.key,
    required this.dialogTitle,
    required this.dialogContent,
    required this.rightButtonTitle,
    required this.onRightPressed,
    required this.leftButtonTitle,
    required this.onLeftPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialogTitle),
      content: Text(dialogContent),
      actions: <Widget>[
        TextButton(onPressed: onLeftPressed, child: Text(leftButtonTitle)),
        TextButton(onPressed: onRightPressed, child: Text(rightButtonTitle)),
      ],
    );
  }
}
