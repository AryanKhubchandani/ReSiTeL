import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hci/screens/camera.dart';

import 'dart:math' as math;
import 'package:tflite/tflite.dart';

import 'bounding_box.dart';

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  const LiveFeed(this.cameras, {Key? key}) : super(key: key);
  @override
  LiveFeedState createState() => LiveFeedState();
}

class LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  initCameras() async {}

  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/labels.txt",
    );
  }

  endTfModel() async {
    await await Tflite.close();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTfModel();
  }

  @override
  void dispose() {
    endTfModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          BoundingBox(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
        ],
      ),
    );
  }
}
