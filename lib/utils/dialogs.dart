import 'package:flutter/material.dart';
import 'package:mycatalog/widgets/app_alertdialog.dart';

class Dialogs {
  static showSnack() {}

  static showInfo(BuildContext c, String title, String msg) {
    showDialog(
        context: c,
        builder: (BuildContext context) {
          return AppAlertDialog(
            title,
            msg,
          );
        });
  }

  static Future<bool> showQuestion(BuildContext c, String title, String msg) {
    return showDialog<bool>(
        context: c,
        builder: (BuildContext context) {
          return AppAlertDialog(
            title,
            msg,
            onYes: () => Navigator.of(context).pop(true),
            onNo: () => Navigator.of(context).pop(false),
          );
        });
  }
}
