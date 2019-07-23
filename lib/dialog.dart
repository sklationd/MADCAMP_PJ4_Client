import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, cancel, confirm, title, description) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("취소"),
    onPressed: cancel,
  );
  Widget continueButton = FlatButton(
    child: Text("확인"),
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