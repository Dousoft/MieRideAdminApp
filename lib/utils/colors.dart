import 'package:flutter/material.dart';

class AppColor {
  static final AppColor _instance = AppColor._internal();
  factory AppColor() => _instance;
  AppColor._internal();

  Color whiteThemeColor = const Color(0xFFFFFFFF);
  Color greenThemeColor = const Color(0xFFD0FF13);
  Color blackThemeColor= const Color(0xFF1C1C1E);
  Color greyThemeColor = Color(0xFFF7F7F7);
  Color greyDarkThemeColor = Color(0xFFE5E5E5);
  Color orangeThemeColor = const Color(0xffFF8000);
  Color redColor = const Color(0xffff0000);
  Color darkerGreyColor = Color(0xFF4F4F4F);
  Color darkGreyColor = Color(0xFF939393);
  Color whiteSecondary = Color(0xFFF7F7F7);
  Color color6B6B6B = Color(0xFF6B6B6B);
  Color colorDD4132 = Color(0xFFDD4132);
  Color color00A431 = Color(0xFF00A431);
  Color color353535 = Color(0xFF353535);
  Color colorFFB500 = Color(0xffFFB500);

}
