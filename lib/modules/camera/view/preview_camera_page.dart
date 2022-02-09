import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportcam/modules/camera/controller/camera_controller.dart';
import 'package:reportcam/modules/camera/view/widget/preview_map_widget.dart';
import 'package:reportcam/modules/main_menu/controller/main_controller.dart';
import 'package:reportcam/modules/main_menu/view/main_menu_page.dart';
import 'package:reportcam/samples/map_samples.dart';
import 'package:reportcam/utils/ad_helper.dart';
import 'package:reportcam/utils/styles.dart';
import 'package:screenshot/screenshot.dart';
import 'package:reportcam/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class PreviewCameraPage extends StatefulWidget {
  const PreviewCameraPage({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;

  @override
  _PreviewCameraPageState createState() => _PreviewCameraPageState();
}

class _PreviewCameraPageState extends State<PreviewCameraPage> {
  //controllers
  final _appCameraController = Get.find<AppCameraController>();
  final _mainMenuController = Get.find<MainController>();
  final ScreenshotController _screenshotController = ScreenshotController();

  // var for ss
  String personName = 'loading.. Person Name';
  String personAddress = 'loading.. Address Now';
  String personAddress2 = '';
  String personAct = 'Loading Person Activity';
  DateTime dateNow = DateTime.now();
  double latUser = 0, lngUser = 0;

  bool isPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserLocation();
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose an InterstitialAd object
    _interstitialAd?.dispose();
    super.dispose();
  }

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    print(AdHelper.interstitialAdUnitId);
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Get.offAll(const MainMenuPage());
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  // get user location data
  bool isLatLngExist = false;
  void getUserLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      setState(() {
        latUser = value.latitude;
        lngUser = value.longitude;
      });
    });
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latUser, lngUser);
    setState(() {
      personName = _mainMenuController.savedPersonName;
      personAct = _mainMenuController.tempSavedActivity;
      personAddress = placemarks[0].street!;
      personAddress2 = placemarks[0].subAdministrativeArea!;
      isLatLngExist = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SafeArea(
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          color: Colors.black87,
                          child: Row(
                            children: [
                              GetBuilder<AppCameraController>(
                                  builder: (context) {
                                return SizedBox(
                                  width: 170,
                                  height: 170,
                                  child: isLatLngExist
                                      ? _appCameraController.isMapImgUrlExist
                                          ? Image.file(
                                              _appCameraController.mapImgFile)
                                          : PreviewMapWidget(
                                              latUser: latUser,
                                              lngUser: lngUser,
                                            )
                                      : const Center(
                                          child: Text('Loading\nThe Map',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                );
                              }),
                              const SizedBox(width: Dimensions.space1),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Reports:',
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        170 -
                                        Dimensions.space1,
                                    child: Text(
                                      personAct,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.space1),
                                  Text(
                                    "${dateNow.year}-${dateNow.month}-${dateNow.day} [ ${dateNow.hour}:${dateNow.minute} ]",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    personName.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "$latUser, $lngUser",
                                    style: const TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        170 -
                                        Dimensions.space1,
                                    child: Text(
                                      "$personAddress : $personAddress2",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          color: AppStyle.primaryColor(),
                          child: const Center(
                            child: Text(
                              "© Shared from Report Camera by BoredVio",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // test 1
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: GetBuilder<AppCameraController>(
                  builder: (context) {
                    return !_appCameraController.isMapImgUrlExist
                        ? Container(
                            height: 70,
                            color: AppStyle.primaryDarkColor(),
                            child: const Center(
                              child: Text(
                                'Preparing Image..',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _appCameraController.isMapImgUrlExist =
                                        false;
                                    _appCameraController.update();
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 70,
                                    color: AppStyle.notOkColor(),
                                    child: const Center(
                                      child: Text(
                                        "Retake",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GetBuilder<AppCameraController>(
                                  builder: (context) {
                                    return InkWell(
                                      onTap: () {
                                        Get.snackbar('Loading',
                                            'Please see this Ad first, then Skip it to Open Share Image Platforms',
                                            backgroundColor: Colors.black,
                                            colorText: Colors.white,
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                        _screenshotController
                                            .capture()
                                            .then((image) async {
                                          final directory =
                                              await getApplicationDocumentsDirectory();
                                          final imagePath = await File(
                                                  '${directory.path}/${personName}_${dateNow.year}${dateNow.month}${dateNow.day}.png')
                                              .create();
                                          await imagePath.writeAsBytes(image!);
                                          Share.shareFiles([
                                            imagePath.path
                                          ], text: '$personName\n\n#$personAct\n@ $personAddress: $personAddress2\n\nShared From Report Camera By Bored Vio')
                                              .then((value) {
                                            // TODO: Display an Interstitial Ad
                                            if (_isInterstitialAdReady) {
                                              _interstitialAd?.show();
                                            } else {
                                              Get.offAll(const MainMenuPage());
                                            }
                                          });
                                        });
                                      },
                                      child: Container(
                                        height: 70,
                                        color: AppStyle.okColor(),
                                        child: const Center(
                                          child: Text(
                                            "Share",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
