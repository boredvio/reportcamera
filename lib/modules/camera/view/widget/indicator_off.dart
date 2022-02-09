import 'package:flutter/material.dart';
import 'package:reportcam/utils/styles.dart';

class IndicatorOff extends StatelessWidget {
  const IndicatorOff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppStyle.primaryDarkColor(),
      ),
    );
  }
}
