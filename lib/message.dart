import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

Future<void> message(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Message'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Lorem ipsum dolor sit amet, consectetur.......'),
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
                child: const Text('Share'),
                onPressed: () {
                  Share.share('check out my website https://example.com');
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
