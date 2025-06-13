import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/theme/theme_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? trailing;
  final String firstText;
  final String secondText;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;
  final bool hasDivider;
  final bool isSecondTextBeforeFirst; // Option to control text order

  const CustomAppBar({
    super.key,
    this.leading,
    this.trailing,
    this.hasDivider = false,
    required this.firstText,
    required this.secondText,
    this.firstTextStyle,
    this.secondTextStyle,
    this.isSecondTextBeforeFirst = false, // Default is first text comes first
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text.rich(
        TextSpan(
          children: [
            if (isSecondTextBeforeFirst)
              TextSpan(
                text: secondText,
                style:
                    secondTextStyle ??
                     TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontFamily: Themetext.fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            TextSpan(
              text: firstText,
              style:
                  firstTextStyle ??
                   TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: Themetext.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (!isSecondTextBeforeFirst)
              TextSpan(
                text: secondText,
                style:
                    secondTextStyle ??
                     TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontFamily: Themetext.fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
              ),
          ],
        ),
        textAlign: TextAlign.center, // Center aligns the text
      ),
      actions:
          trailing != null
              ? [trailing!]
              : [SizedBox(width: 48)], // Maintain symmetry
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
