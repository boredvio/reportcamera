import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reportcam/modules/camera/controller/camera_controller.dart';
import 'package:reportcam/modules/camera/view/camera_page.dart';
import 'package:reportcam/modules/camera/view/widget/guide_camera_item_pager_widget.dart';
import 'package:reportcam/modules/camera/view/widget/indicator_off.dart';
import 'package:reportcam/modules/camera/view/widget/indicator_on.dart';
import 'package:reportcam/modules/main_menu/controller/main_controller.dart';
import 'package:reportcam/utils/dimens.dart';
import 'package:reportcam/modules/main_menu/view/main_menu_page.dart';
import 'package:reportcam/utils/ad_helper.dart';
import 'package:get/get.dart';
import 'package:reportcam/utils/styles.dart';
import 'package:reportcam/widgets/app_btn.dart';

class GuideCamera extends StatefulWidget {
  const GuideCamera({Key? key}) : super(key: key);

  @override
  _GuideCameraState createState() => _GuideCameraState();
}

class _GuideCameraState extends State<GuideCamera> {
  // init camera controller
  final AppCameraController _cameraController = Get.put(AppCameraController());
  final _mainMenuController = Get.find<MainController>();

  // for forms
  TextEditingController personAct = TextEditingController();

  // var for cameras
  late CameraDescription frontCamera;
  late CameraDescription rearCamera;

  Future<void> activateCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    frontCamera = cameras[1];
    rearCamera = cameras[0];
  }

  // var for pager
  int pageNumb = 0;

  //for ad
  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {
    // TODO: implement initState
    activateCamera();

    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: pageNumb);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(Dimensions.space2),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: PageView(
                  onPageChanged: (int page) {
                    setState(() {
                      pageNumb = page;
                    });
                    print(page);
                  },
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    const GuideCameraItemPagerWidget(
                      imageUrl: 'assets/images/flat_selfie.png',
                      imageDesc: 'Take the photo or selfie',
                    ),
                    const GuideCameraItemPagerWidget(
                      imageUrl: 'assets/images/flat_preview.png',
                      imageDesc: 'Check the preview photo',
                    ),
                    const GuideCameraItemPagerWidget(
                      imageUrl: 'assets/images/flat_ad.png',
                      imageDesc: 'See & Skip the Ad',
                    ),
                    const GuideCameraItemPagerWidget(
                      imageUrl: 'assets/images/flat_share.png',
                      imageDesc: 'Share the photo',
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.note_alt,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: Dimensions.space1,
                            ),
                            const Text(
                              'Fill the form below first, to start the Report',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.space1),
                        const Text(
                          'What activity do you want to report?',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              // border: InputBorder.none,
                              // focusedBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              hintText: 'Ex: Checking on Something_',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18)),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.center,
                          controller: personAct,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            _mainMenuController.tempSavedActivity =
                                personAct.text;
                            print(
                                "saved temp act : ${_mainMenuController.tempSavedActivity}");
                            Get.to(() => CameraPage(
                                frontCamera: frontCamera,
                                rearCamera: rearCamera));
                          },
                          // controller: _mainController.personName,
                        ),
                        const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pageNumb == 0 ? const IndicatorOn() : const IndicatorOff(),
                  const SizedBox(width: 10),
                  pageNumb == 1 ? const IndicatorOn() : const IndicatorOff(),
                  const SizedBox(width: 10),
                  pageNumb == 2 ? const IndicatorOn() : const IndicatorOff(),
                  const SizedBox(width: 10),
                  pageNumb == 3 ? const IndicatorOn() : const IndicatorOff(),
                  const SizedBox(width: 10),
                  pageNumb == 4 ? const IndicatorOn() : const IndicatorOff(),
                ],
              ),
              const Spacer(),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   height: 60,
              //   child: AppButton(
              //       textButton: 'Open Camera',
              //       colorButton: AppStyle.primaryColor(),
              //       onTap: () {
              //         Get.to(() => CameraPage(
              //             frontCamera: frontCamera, rearCamera: rearCamera));
              //       }),
              // ),
              // const SizedBox(
              //   height: Dimensions.space2,
              // ),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
