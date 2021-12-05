import 'package:flutter/material.dart';
import 'package:hci/screens/camera.dart';

import 'package:share_plus/share_plus.dart';

class FinalMessage extends StatelessWidget {
  final List<String> finalText;

  FinalMessage({required this.finalText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Message'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(finalText.join()),
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
                CameraFeedState().finalText = [];
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Share"),
              onPressed: () {
                Share.share(finalText.join());
                Navigator.of(context).pop();
                CameraFeedState().finalText = [];
              },
            ),
          ],
        ),
      ],
    );
  }
}
