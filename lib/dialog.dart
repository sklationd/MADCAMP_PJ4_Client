import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, cancel, confirm, title, description) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("아니오"),
    onPressed: cancel,
  );
  Widget continueButton = FlatButton(
    child: Text("예"),
    onPressed: confirm,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}