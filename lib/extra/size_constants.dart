import 'package:flutter/material.dart';

class SizeConstants {
  static const double opacity = 0.1;
  static const int heightTextButton = 5;
  static const int widthTextButton = 15;

  //fontSize
  static const double listItemCount = 12;
  static const double listItemText = 12;

  static const double PdflistItemText = 12;

}

class Responsive {

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static const double designWidth = 417;
  static const double designHeight = 917;

  static late double scaleWidth;
  static late double scaleHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    scaleWidth = screenWidth / designWidth;
    scaleHeight = screenHeight / designHeight;
  }

  static double w(double width) {
    return width * scaleWidth;
  }

  static double h(double height) {
    return height * scaleHeight;
  }

  static double sp(double fontSize) {
    return fontSize * scaleWidth;
  }
}

class Spacing {

  static double xs = Responsive.w(4);
  static double sm = Responsive.w(8);
  static double md = Responsive.w(16);
  static double lg = Responsive.w(24);
  static double xl = Responsive.w(32);

}

class Sizes {

  static double buttonHeight = Responsive.h(48);
  static double cardRadius = Responsive.w(12);
  static double icon = Responsive.w(24);
  static double avatar = Responsive.w(48);

}

class AppTextStyles {

  static TextStyle heading = TextStyle(
    fontSize: Responsive.sp(22),
    fontWeight: FontWeight.bold,
  );

  static TextStyle body = TextStyle(
    fontSize: Responsive.sp(16),
  );

  static TextStyle small = TextStyle(
    fontSize: Responsive.sp(12),
  );

}