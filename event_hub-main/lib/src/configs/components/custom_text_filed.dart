import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/configs/theme/theme_text.dart';
import 'package:event_hub/src/configs/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Color color;
  final Color borderColor;

  final bool isPassword;
  final bool showTitle;
  final bool autoDismissKeyboard;
  final bool isReadOnly;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.color = Colors.transparent,
    this.borderColor = Colors.black38,
    this.isPassword = false,
    this.isReadOnly = false,
    this.showTitle = true,
    this.autoDismissKeyboard = true,
    this.minLines = 1,
    this.maxLines,
    this.validator, // Add the validator here
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[Text(widget.hintText), SizedBox(height: 5.h)],

        Container(
          // height: 35.h,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: widget.keyboardType ?? TextInputType.text,
                  readOnly: widget.isReadOnly,
                  controller: widget.controller,
                  cursorColor: AppColors.primary,
                  cursorHeight: 18,
                  obscureText: widget.isPassword ? _isObscure : false,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: Themetext.medium500,
                  ),
                  minLines: widget.minLines,
                  maxLines: widget.isPassword ? 1 : widget.maxLines,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  onTapOutside: (event) {
                    if (widget.autoDismissKeyboard) {
                      Utils.dismissKeyboard(context);
                    }
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.sp,
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: 'Please Enter  ${widget.hintText}',
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w200,
                      fontSize: 15,
                    ),

                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  onChanged: (value) {},
                  validator: widget.validator,
                ),
              ),
              // if (widget.isPassword)
              IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color:
                      widget.isPassword ? Colors.black38 : Colors.transparent,
                ),
                onPressed:
                    widget.isPassword
                        ? () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
