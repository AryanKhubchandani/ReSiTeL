import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import '../camera_page.dart';
import '../message.dart';

typedef void Callback(List<dynamic> list, int h, int w);
FlashMode? _currentFlashMode;
bool _isFrontCameraSelected = true;
bool _isFlashOn = false;

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  CameraFeed(this.cameras, this.setRecognitions);

  @override
  _CameraFeedState createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  late CameraController controller;
  bool isDetecting = false;
  late AnimateIconController animatedController;

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

    // // Update the boolean
    // if (mounted) {
    //   setState(() {
    //     _isCameraInitialized = controller.value.isInitialized;
    //   });
    // }
  }

  @override
  void initState() {
    animatedController = AnimateIconController();

    super.initState();

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
              /*
              When setRecognitions is called here, the parameters are being passed on to the parent widget as callback. i.e. to the LiveFeed class
               */
              widget.setRecognitions(recognitions!, img.height, img.width);
              isDetecting = false;
            });
          }
        });
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

    // return OverflowBox(
    //   maxHeight:
    //       screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
    //   maxWidth:
    //       screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
    //   child: CameraPreview(controller),
    // );
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
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
                              children: const [],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    // setState(() {
                    //   _isCameraInitialized = false;
                    // });
                    onNewCameraSelected(
                      cameras[_isFrontCameraSelected ? 0 : 1],
                    );
                    setState(() {
                      _isFrontCameraSelected = !_isFrontCameraSelected;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.black38,
                        size: 60,
                      ),
                      Icon(
                        _isFrontCameraSelected
                            ? Icons.camera_rear
                            : Icons.camera_front,
                        color: Colors.white,
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
                      onEndIconPress: () {
                        message(context);
                        print("Stop button pressed");

                        return true;
                      },
                      onStartIconPress: () {
                        print("Start button pressed");
                        return true;
                      },
                    ),
                  ],
                ),
                InkWell(
                    onTap: () async {
                      setState(() {
                        _isFlashOn = !_isFlashOn;
                        _currentFlashMode = FlashMode.always;
                      });
                      _isFlashOn
                          ? controller.setFlashMode(FlashMode.torch)
                          : controller.setFlashMode(FlashMode.off);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.black38,
                          size: 60,
                        ),
                        Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    )),
              ],
            ),
          ],
        )
        // : const Center(
        //     child: Text(
        //       'LOADING..',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        );
  }
}
