import 'package:flutter/material.dart';

Future showMyDialog(context, String title, String msg,
    {int disposeAfterMillis = 2000, bool isError = true}) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      Future.delayed(Duration(milliseconds: disposeAfterMillis), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });
      return AlertDialog(
        title: Center(
          child: Text(title,
              style: TextStyle(
                  color: isError ? Colors.red : Colors.green, fontSize: 22)),
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}
