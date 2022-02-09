import 'package:flutter/material.dart';
import 'package:reportcam/utils/styles.dart';

class GuideCameraItemPagerWidget extends StatelessWidget {
  const GuideCameraItemPagerWidget(
      {Key? key, required this.imageUrl, required this.imageDesc})
      : super(key: key);
  final String imageUrl;
  final String imageDesc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          // Container(
          //   width: 200,
          //   height: 200,
          //   color: AppStyle.primaryColor(),
          // ),
          Image.asset(imageUrl, width: 200, height: 200),
          const Spacer(),
          SizedBox(
            width: 300,
            child: Text(
              imageDesc,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(color: Color(0xFFEBEBEB)),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
