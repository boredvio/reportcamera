import 'package:flutter/material.dart';

class AppStyle {
  static Color primaryColor() {
    return const Color(0xFF2C55BA);
  }

  static Color primaryDarkColor() {
    return const Color(0xFF293960);
  }

  static Color okColor() {
    return const Color(0xFF23C751);
  }

  static Color notOkColor() {
    return const Color(0xFFE23D27);
  }

  static Color disabledColor() {
    return const Color(0xFFC0C0C0);
  }

  static InputDecoration mainInput({required String hint}) {
    return InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 10), //Change this value to custom as you like
        isDense: true,
        hintText: hint);
  }
}
