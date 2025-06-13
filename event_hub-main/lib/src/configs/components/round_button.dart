import 'package:event_hub/src/configs/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color/color.dart';

// ignore: must_be_immutable
class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  Widget? icon;
  // Optional parameters with default values
  final double? height; // Nullable to calculate dynamically if not provided
  final double? width;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color loadingIndicatorColor;

  RoundButton({
    super.key,
    required this.title,
    this.loading = false,
    required this.onPress,
    this.height,
    this.icon,
    this.width,
    this.textColor = AppColors.white,
    this.color = AppColors.primary,
    this.borderColor = Colors.transparent,
    this.borderRadius = 10.0,
    this.textStyle,
    this.loadingIndicatorColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: height ?? context.mediaQueryHeight / 18,
        width: width ?? context.mediaQueryWidth / 1.2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child:
              loading
                  ? CircularProgressIndicator(color: loadingIndicatorColor)
                  : FittedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment:
                          icon != null
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[icon ?? SizedBox()],
                        if (icon != null) ...[SizedBox(width: 5)],
                        Text(
                          title,
                          style:
                              textStyle ??
                              TextStyle(
                                color: textColor,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        if (icon != null) ...[SizedBox()],
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
