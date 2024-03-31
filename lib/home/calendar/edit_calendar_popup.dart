import 'package:flutter/material.dart';

class EditCalendarPopup extends StatelessWidget {
  const EditCalendarPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
