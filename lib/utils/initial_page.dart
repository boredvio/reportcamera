import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reportcam/modules/main_menu/view/main_menu_page.dart';
import 'package:reportcam/utils/dimens.dart';
import 'package:reportcam/utils/styles.dart';
import 'dimens.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 3), () {
      print("nav-to: mainmenu_page");
      Get.offAll(() => const MainMenuPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/flat_ss.png', width: 200, height: 200),
              const SizedBox(height: Dimensions.space2),
              const Text(
                'Report Camera',
                style: TextStyle(color: Colors.white),
              ),
              const Text(
                'by BoredVio',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: Dimensions.space1),
              const Text(
                'Ver. 0.1',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
