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
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        onYes != null
            ? FlatButton(
                child: Text('Sim'),
                onPressed: () => onYes(),
              )
            : null,
        onNo != null
            ? FlatButton(
                child: Text('Não'),
                onPressed: () => onNo(),
              )
            : FlatButton(
                child: Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
      ],
    );
  }
}
