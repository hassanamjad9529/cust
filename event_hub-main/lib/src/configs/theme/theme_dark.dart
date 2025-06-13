// themedark.dart
import 'package:event_hub/src/configs/color/color.dart';
import 'package:flutter/material.dart';

class Themedark {
  Themedark._();

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: appbarTheme,
    // textTheme: Themetext.textTheme.apply(bodyColor: Colors.white),
    useMaterial3: true,
    elevatedButtonTheme: elevatedButtonTheme,
  );
  static AppBarTheme appbarTheme = const AppBarTheme(
      backgroundColor: AppColors.white,
      titleTextStyle: TextStyle(color: AppColors.primary));



  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      minimumSize: const Size(327.0, 56.0),
    ),
  );
}
