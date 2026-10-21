import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColor.primary,
          primary: MyColor.primary,
          secondary: MyColor.gold,
          brightness: Brightness.light,
        ),
        primaryColor: MyColor.primary,
        scaffoldBackgroundColor: MyColor.homeBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: MyColor.white,
          foregroundColor: MyColor.primary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.primary,
            foregroundColor: MyColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColor.primary,
          secondary: MyColor.gold,
          brightness: Brightness.dark,
        ),
        primaryColor: MyColor.gold,
        dividerColor: Colors.white12,
      );
}
