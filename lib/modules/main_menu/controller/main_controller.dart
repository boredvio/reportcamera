import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reportcam/utils/styles.dart';

class MainController extends GetxController {
  Future<void> _checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _checkMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _checkLocPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  // permissionCheckAll
  bool isAllAllowedPermission = false;
  Future<void> _checkAllPermission() async {
    if (isAllAllowedPermission == false) {
      _checkStoragePermission().then((value) => _checkCameraPermission().then(
          (value) =>
              _checkMicPermission().then((value) => _checkLocPermission())));
    } else {
      isAllAllowedPermission = false;
    }
  }

  // write name
  TextEditingController personName = TextEditingController();
  bool isSavedPersonNameExist = false;
  String savedPersonName = '';
  String tempSavedActivity = '';

  Future<void> savePersonName({required String personName}) async {
    final box = GetStorage();
    box.write('savedPersonName', personName);
    savedPersonName = personName;
    update();
    Get.snackbar(personName, 'Successfully saved as new user',
        backgroundColor: AppStyle.primaryColor(),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    final box = GetStorage();
    var checkPersonName = box.read('savedPersonName');

    if (checkPersonName == null) {
      savedPersonName = 'Just A Person\n(Edit on Main Menu)';
    } else {
      personName.text = box.read("savedPersonName");
      savedPersonName = box.read('savedPersonName');
      isSavedPersonNameExist = true;
    }

    _checkAllPermission();
    super.onInit();
  }
}
