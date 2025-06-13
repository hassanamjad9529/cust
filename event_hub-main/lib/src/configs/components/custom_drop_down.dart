// Dropdown validation
import 'package:event_hub/src/configs/extensions.dart';
import 'package:event_hub/src/configs/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String? dropdownValidator<T>(T? value, String label) {
  if (value == null) {
    return '$label is required';
  }
  return null;
}

// ignore: non_constant_identifier_names
Widget CustomDropdown<T>(
  String label,
  T value,
  List<T> items,
  Function(T?) onChanged, {
  String? Function(T?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      SizedBox(height: 5.h),
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black38),
        ),
        child: DropdownButtonFormField<T>(
          value: value,

          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black38, fontSize: 16.sp),
            contentPadding: EdgeInsets.only(left: 10.w),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),

          dropdownColor: Colors.white,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(
                        e.toString().split('.').last.capitalizeFirstLetter(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: Themetext.regular400,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          validator: validator ?? (value) => dropdownValidator(value, label),
        ),
      ),
    ],
  );
}
