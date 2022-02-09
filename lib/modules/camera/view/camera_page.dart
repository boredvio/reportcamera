import 'dart:io';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportcam/modules/camera/controller/camera_controller.dart';
import 'package:reportcam/modules/camera/view/preview_camera_page.dart';
import 'package:reportcam/utils/styles.dart';
import 'package:screenshot/screenshot.dart';
import 'package:reportcam/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
    required this.frontCamera,
    required this.rearCamera,
  }) : super(key: key);

  final CameraDescription frontCamera;
  final CameraDescription rearCamera;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final _appCameraController = Get.find<AppCameraController>();

  bool camerasBool = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.frontCamera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.

    try {
      _initializeControllerFuture = _controller.initialize();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Your Photo'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.black,
            // Provide an onPressed callback.
            onPressed: () async {
              if (camerasBool == false) {
                setState(() {
                  camerasBool = true;
                  _controller = CameraController(
                    // Get a specific camera from the list of available cameras.
                    widget.rearCamera,
                    // Define the resolution to use.
                    ResolutionPreset.high,
                  );
                  // Next, initialize the controller. This returns a Future.
                  _initializeControllerFuture = _controller.initialize();
                });
              } else {
                setState(() {
                  camerasBool = false;
                  _controller = CameraController(
                    // Get a specific camera from the list of available cameras.
                    widget.frontCamera,
                    // Define the resolution to use.
                    ResolutionPreset.high,
                  );
                  // Next, initialize the controller. This returns a Future.
                  _initializeControllerFuture = _controller.initialize();
                });
              }

              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.autorenew),
          ),
          const SizedBox(height: Dimensions.space2),
          FloatingActionButton(
            backgroundColor: AppStyle.primaryColor(),
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();
                _appCameraController.selfieImage =
                    await _controller.takePicture();
                // If the picture was taken, display it on a new screen.
                // await Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => PreviewCameraPage(
                //       // Pass the automatically generated path to
                //       // the DisplayPictureScreen widget.
                //       imagePath: image.path,
                //     ),
                //   ),
                // );
                await Get.to(() => PreviewCameraPage(imagePath: image.path));
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: Dimensions.space2),
        ],
      ),
    );
  }
}
