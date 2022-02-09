import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AppCameraController extends GetxController {
  // data inputs checkin
  late CameraController _cameraController;
  late XFile selfieImage = XFile('');
  late String mapImgUrl;
  File mapImgFile = File('');
  bool isMapImgUrlExist = false;

  void saveMapImage({required bool boolValue, required File fileImage}) {
    mapImgFile = fileImage;
    isMapImgUrlExist = boolValue;
    update();
  }

  void updateImgMapExist({required bool boolValue}) {
    isMapImgUrlExist = boolValue;
    update();
  }
}
