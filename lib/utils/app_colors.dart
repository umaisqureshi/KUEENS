import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors{
  static const primaryColor = Color(0xff7D2C91);

 static MaterialColor generateMaterialColor() {
    return MaterialColor(primaryColor.value, {
      50: tintColor(primaryColor, 0.9),
      100: tintColor(primaryColor, 0.8),
      200: tintColor(primaryColor, 0.6),
      300: tintColor(primaryColor, 0.4),
      400: tintColor(primaryColor, 0.2),
      500: primaryColor,
      600: shadeColor(primaryColor, 0.1),
      700: shadeColor(primaryColor, 0.2),
      800: shadeColor(primaryColor, 0.3),
      900: shadeColor(primaryColor, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

 static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

 static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

 static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}