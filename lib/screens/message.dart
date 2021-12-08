import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hci/screens/camera.dart';

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
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Share"),
              onPressed: () {
                HapticFeedback.lightImpact();
                uploadingData(finalText.join());
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

Future<void> uploadingData(String content) async {
  await FirebaseFirestore.instance.collection("messages").add({
    'content': content,
    'createdOn': FieldValue.serverTimestamp(),
  });
}
