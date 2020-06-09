import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onYes;
  final Function onNo;

  AppAlertDialog(this.title, this.content, {this.onYes, this.onNo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        onYes == null
            ? FlatButton(
                child: Text(tr('ok')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        onYes != null
            ? FlatButton(
                child: Text(tr('yes')),
                onPressed: () => onYes(),
              )
            : null,
        onNo != null
            ? FlatButton(
                child: Text(tr('no')),
                onPressed: () => onNo(),
              )
            : FlatButton(
                child: Text(tr('no')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
      ],
    );
  }
}
