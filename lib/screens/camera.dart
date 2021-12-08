import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:hci/models/detection/live_camera.dart';
import 'package:hci/screens/message.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera_page.dart';
import 'home_page.dart';

typedef void Callback(List<dynamic> list, int h, int w);
FlashMode? _currentFlashMode;
bool _isFrontCameraSelected = true;
bool _isFlashOn = false;

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  CameraFeed(this.cameras, this.setRecognitions);

  @override
  CameraFeedState createState() => CameraFeedState();
}

class CameraFeedState extends State<CameraFeed> {
  late CameraController controller;
  bool isDetecting = false;
  late AnimateIconController animatedController;
  LiveFeedState liveFeedState = LiveFeedState();
  List<String> finalText = [];

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }
    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
      _currentFlashMode = controller.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void initState() {
    animatedController = AnimateIconController();

    super.initState();
    finalText = [];
    print(widget.cameras);
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No Cameras Found.');
    } else {
      controller = CameraController(
        widget.cameras[1],
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1 / controller.value.aspectRatio,
              child: Stack(
                children: [
                  // controller!.buildPreview(),
                  CameraPreview(controller),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      8.0,
                      16.0,
                      8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // setState(() {
                                    //   _isCameraInitialized = false;
                                    // });
                                    onNewCameraSelected(
                                      cameras[_isFrontCameraSelected ? 0 : 1],
                                    );
                                    setState(() {
                                      _isFrontCameraSelected =
                                          !_isFrontCameraSelected;
                                      _isFlashOn = false;
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.black38,
                                        size: 45,
                                      ),
                                      Icon(
                                        _isFrontCameraSelected
                                            ? Icons.camera_rear
                                            : Icons.camera_front,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        _isFlashOn = !_isFlashOn;
                                        _currentFlashMode = FlashMode.always;
                                      });
                                      _isFlashOn
                                          ? controller
                                              .setFlashMode(FlashMode.torch)
                                          : controller
                                              .setFlashMode(FlashMode.off);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.black38,
                                          size: 45,
                                        ),
                                        Icon(
                                          _isFlashOn
                                              ? Icons.flash_on
                                              : Icons.flash_off,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  (() {
                    if (finalText.isEmpty) {
                      return "Your message will appear here";
                    }
                    return finalText.join();
                  })(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (finalText.isNotEmpty) {
                      finalText.removeLast();
                      setState(() {});
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(
                        Icons.circle,
                        color: Colors.black38,
                        size: 60,
                      ),
                      Icon(
                        Icons.backspace,
                        color: Colors.red,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.black38,
                      size: 80.0,
                    ),
                    AnimateIcons(
                      startIcon: Icons.play_arrow,
                      endIcon: Icons.stop,
                      controller: animatedController,
                      size: 60.0,
                      startIconColor: Colors.green,
                      endIconColor: Colors.red,
                      onStartIconPress: () {
                        HapticFeedback.lightImpact();
                        controller.startImageStream((CameraImage img) {
                          if (!isDetecting) {
                            isDetecting = true;
                            Tflite.detectObjectOnFrame(
                              bytesList: img.planes.map((plane) {
                                return plane.bytes;
                              }).toList(),
                              model: "SSDMobileNet",
                              imageHeight: img.height,
                              imageWidth: img.width,
                              imageMean: 127.5,
                              imageStd: 127.5,
                              numResultsPerClass: 1,
                              threshold: 0.4,
                            ).then((recognitions) {
                              widget.setRecognitions(
                                  recognitions!, img.height, img.width);
                              if (recognitions[0]['confidenceInClass'] * 100 >
                                  73) {
                                finalText.add(recognitions[0]['detectedClass']);
                              }
                              isDetecting = false;
                            });
                          }
                        });
                        didUpdateWidget(CameraFeed(cameras, (list, h, w) {}));
                        return true;
                      },
                      onEndIconPress: () {
                        isDetecting = false;
                        HapticFeedback.lightImpact();
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return FinalMessage(finalText: finalText);
                            });
                        return true;
                      },
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      finalText.add(" ");
                      setState(() {});
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(
                          Icons.circle,
                          color: Colors.black38,
                          size: 60,
                        ),
                        Icon(
                          Icons.space_bar,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
