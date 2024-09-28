import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:toastification/toastification.dart';

import 'constants.dart';

void showToast(BuildContext context,
    {required String title,
    required String description,
    ToastificationType? type,
    String? id}) async {
  toastification.show(
      context: context,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(title),
      description: Text(description),
      type: type);
}

void showSnackbar(String? text,Color? color) {
  // Remove spamming of snackbars.
  ScaffoldMessenger.of(appNavigationKey.currentContext!).clearSnackBars();

  ScaffoldMessenger.of(appNavigationKey.currentContext!)
      .showSnackBar(SnackBar(content: Text('$text'),backgroundColor: color,));
}

void showAlert(String title, String? message, TypeAlert typeAlert) {
  AlertController.show(title, message ?? 'Something happened...', typeAlert);
}
