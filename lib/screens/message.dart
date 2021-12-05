import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

class FinalMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Message'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text("THIS IS SAMPLE"),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Share"),
              onPressed: () {
                Share.share("");
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
