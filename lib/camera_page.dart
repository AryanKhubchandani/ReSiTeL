import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:animate_icons/animate_icons.dart';

List<CameraDescription> cameras = [];
FlashMode? _currentFlashMode;
bool _isRearCameraSelected = false;
bool _isFlashOn = false;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final int _page = 1;
  late PageController _c;
  CameraController? controller;
  bool _isCameraInitialized = false;
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
    await previousCameraController?.dispose();

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
      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    _c = PageController(
      keepPage: true,
      initialPage: _page,
    );
    onNewCameraSelected(cameras[1]);
    animatedController = AnimateIconController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // bool onEndIconPress(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Stop"),
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  //   return true;
  // }

  // bool onStartIconPress(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Record"),
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  //   return true;
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(controller),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / controller!.value.aspectRatio,
                  child: Stack(
                    children: [
                      controller!.buildPreview(),
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
                                        setState(() {
                                          _isCameraInitialized = false;
                                        });
                                        onNewCameraSelected(
                                          cameras[
                                              _isRearCameraSelected ? 0 : 1],
                                        );
                                        setState(() {
                                          _isRearCameraSelected =
                                              !_isRearCameraSelected;
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
                                            _isRearCameraSelected
                                                ? Icons.camera_rear
                                                : Icons.camera_front,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _isFlashOn = !_isFlashOn;
                                            _currentFlashMode =
                                                FlashMode.always;
                                          });
                                          _isFlashOn
                                              ? controller!
                                                  .setFlashMode(FlashMode.torch)
                                              : controller!
                                                  .setFlashMode(FlashMode.off);
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
                                              _isFlashOn
                                                  ? Icons.flash_on
                                                  : Icons.flash_off,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'LOADING..',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
