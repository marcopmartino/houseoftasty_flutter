import 'package:flutter/material.dart';

class AppColors {
  static const Color sandBrown = Color(0xFFFAEADE);
  static const Color darkSandBrown = Color(0xFFF1D7C3);
  static const Color caramelBrown = Color(0xFFD19266);
  static const Color transparentCaramelBrown = Color(0x66D19266);
  static const Color tawnyBrown = Color(0xFFC37F4F);
  static const Color grayBrown = Color(0xFFDAC1AF);
  static const Color transparentGrayBrown = Color(0x66DAC1AF);
  static const Color lightRed = Color(0xFFFF7F7F);
  static const Color heartRed = Color(0xFFFF3333);
  static const Color darkRed = Color(0xFFCC0000);
  static const Color lightOrange = Color(0xFFFFAA60);
  static const Color darkOrange = Color(0xFFFF5C00);

  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}