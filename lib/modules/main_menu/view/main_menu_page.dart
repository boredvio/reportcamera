import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reportcam/modules/camera/view/guide_camera_page.dart';
import 'package:reportcam/modules/main_menu/controller/main_controller.dart';
import 'package:reportcam/samples/map_samples.dart';
import 'package:reportcam/utils/ad_helper.dart';
import 'package:reportcam/utils/dimens.dart';
import 'package:get/get.dart';
import 'package:reportcam/utils/styles.dart';
import 'package:reportcam/widgets/app_btn.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  // init main controller
  final MainController _mainController = Get.put(MainController());

  //for ad
  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {
    // TODO: implement initState

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
    _mainController.savePersonName;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: Dimensions.space2,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Image.asset('assets/images/flat_ss.png',
                        width: 100, height: 100),
                    const SizedBox(
                      height: Dimensions.space1,
                    ),
                    const Text(
                      "Welcome to Report Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      "by Bored Vio",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: Dimensions.space1,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            // border: InputBorder.none,
                            // focusedBorder: InputBorder.none,
                            // enabledBorder: InputBorder.none,
                            // errorBorder: InputBorder.none,
                            // disabledBorder: InputBorder.none,
                            hintText: 'Enter your name here_',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 24)),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        controller: _mainController.personName,
                        onEditingComplete: () async {
                          FocusScope.of(context).unfocus();
                          _mainController.savePersonName(
                              personName: _mainController.personName.text);
                          print('Person Name Saved');
                        },
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.space1,
                    ),
                    // FloatingActionButton(
                    //   backgroundColor: AppStyle.primaryColor(),
                    //   // Provide an onPressed callback.
                    //   onPressed: () async {

                    //   },
                    //   child: const Icon(Icons.note_alt),
                    // ),
                    // const SizedBox(
                    //   height: Dimensions.space1,
                    // ),
                    // const Text(
                    //   "Tap button above to save",
                    //   style: TextStyle(color: Colors.grey),
                    // ),
                  ],
                ),
              ),
              const Spacer(),
              // TODO: Display a banner when ready

              const Text(
                "© Report Camera by BoredVio",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: Dimensions.space1,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                margin:
                    const EdgeInsets.symmetric(horizontal: Dimensions.space2),
                child: AppButton(
                    textButton: 'Take Photo',
                    colorButton: AppStyle.primaryColor(),
                    onTap: () {
                      Get.to(() => const GuideCamera());
                    }),
              ),
              const SizedBox(
                height: Dimensions.space2,
              ),
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
