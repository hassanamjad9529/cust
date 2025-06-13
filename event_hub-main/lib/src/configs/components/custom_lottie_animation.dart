import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomLottieAnimation extends StatelessWidget {
  final String message;
  const CustomLottieAnimation({super.key, this.message = 'No Event Found.'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/animation.json'),
          SizedBox(height: 12.h),
          Text(message, style: TextStyle(fontSize: 23.sp)),
        ],
      ),
    );
  }
}