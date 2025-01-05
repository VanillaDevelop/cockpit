import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// Shows an error message in a flushbar
void showError(BuildContext context, String message,
    {void Function()? onDismiss}) {
  Flushbar(
    title: 'Error',
    message: message,
    icon: const Icon(
      Icons.error_outline,
      color: Colors.red,
    ),
    leftBarIndicatorColor: Colors.red,
    duration: const Duration(seconds: 3),
    onStatusChanged: (status) {
      if (status == FlushbarStatus.DISMISSED) {
        if (onDismiss != null) {
          onDismiss();
        }
      }
    },
  ).show(context);
}
