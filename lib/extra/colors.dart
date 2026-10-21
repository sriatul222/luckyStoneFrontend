import 'package:flutter/material.dart';

class MyColor {
  // Lucky Stone brand (royal plum + gold, jewellery style)
  static const primary = Color(0xFF4A1D5F);
  static const primaryDark = Color(0xFF2E0F3D);
  static final primaryWithOpacity = primary.withValues(alpha: 0.5);
  static const primaryBg = Color(0xFFF5EEF8);
  static const gold = Color(0xFFC9A227);
  static const goldDark = Color(0xFF9C7A12);
  static const goldLight = Color(0xFFF7EDCF);
  static const roseGold = Color(0xFFB76E79);
  static const silver = Color(0xFFA8A9AD);
  static const platinum = Color(0xFFE5E4E2);
  static const success = Color(0xFF2E7D32);
  static const discountRed = Color(0xFFD32F2F);

  static const darkGrey = Color(0xFF282b2f);
  static final lightGray = Colors.grey.withValues(alpha: 0.3);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static final blackOpacity = Colors.black.withValues(alpha: 0.7);
  static const hintColor = Color(0xFF747474);
  static const homeBackgroundColor = Color(0xffFFFFFF);
  static const buttonColor = primary;
  static const redColor = Colors.redAccent;
  static const yellowColor = Colors.yellow;

  static Color mintGreen = const Color(0xFF32B6B5);
  static Color orange = const Color(0xFFF7961D);
  static Color richRed = const Color(0xFFD12C27);
  static Color darkMaroon = const Color(0xFF690C0D);
  static Color oceanBlue = const Color(0xFF0458A2);
  static Color oceanBlueBg = const Color(0xFF0458A2).withValues(alpha: .2);
  static Color blue = const Color(0xFF1A9BD7);
  static Color primaryGrey = const Color(0xFF656579);

  static Color secondaryText = const Color(0xFF2B2B2B);
  static Color primaryText = const Color(0xFF000000);

  static MaterialColor primarySwatch = const MaterialColor(
    0xFF4A1D5F,
    <int, Color>{
      50: Color(0xFFF5EEF8),
      100: Color(0xFFE4D2EC),
      200: Color(0xFFCFB0DD),
      300: Color(0xFFB98ECE),
      400: Color(0xFF9B66B5),
      500: Color(0xFF4A1D5F),
      600: Color(0xFF431A56),
      700: Color(0xFF3A164B),
      800: Color(0xFF331341),
      900: Color(0xFF2E0F3D),
    },
  );
}
