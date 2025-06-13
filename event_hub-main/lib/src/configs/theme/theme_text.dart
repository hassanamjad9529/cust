import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Themetext {
  Themetext._();
  // static const String fontFamily = 'Roboto';
  static  String fontFamily = GoogleFonts.plusJakartaSans().fontFamily!;
  // static const String fontFamily = 'Plus Jakarta Sans'; // or 'Manrope'

  // Font sizes
  static double smallSize = 13.0.sp;
  static double mediumSize = 15.sp;
  static double largeSize = 18.sp;
  static double extraLargeSize = 24.sp;

  // Font weights
  static const FontWeight light300 = FontWeight.w300;
  static const FontWeight regular400 = FontWeight.w400;
  static const FontWeight medium500 = FontWeight.w500;
  static const FontWeight semiBold600 = FontWeight.w600;
  static const FontWeight bold700 = FontWeight.w700;

  // TextTheme for global usage
  static TextTheme textTheme =  TextTheme(
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: largeSize,
      fontWeight: bold700,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: mediumSize,
      fontWeight: regular400,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: smallSize,
      fontWeight: regular400,
    ),
  );

  // Additional reusable text styles
  static TextStyle headline =  TextStyle(
    fontFamily: fontFamily,
    fontSize: largeSize,
    fontWeight: semiBold600,
  );

  static TextStyle superHeadline =  TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: bold700,
    color: Colors.black,
  );

  static TextStyle subheadline =  TextStyle(
    fontFamily: fontFamily,
    fontSize: largeSize,
    fontWeight: bold700,
  );

  static TextStyle greyText =  TextStyle(
    fontFamily: fontFamily,
    fontSize: mediumSize,
    fontWeight: regular400,
    color: Color(0xFF9E9E9E),
  );

  static TextStyle whiteText =  TextStyle(
    fontFamily: fontFamily,
    fontSize: mediumSize,
    fontWeight: medium500,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle blackBoldText =  TextStyle(
    fontFamily: fontFamily,
    fontSize: mediumSize,
    fontWeight: bold700,
    color: Color(0xFF000000),
  );
}
