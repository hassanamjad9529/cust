import 'package:event_hub/src/configs/color/color.dart';
import 'package:flutter/material.dart';

class Utils {
  // Function to dismiss the keyboard
  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // we will use this function to shift focus from one text field to another text field
  // we are using to avoid duplications of code
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  // we will utilise this for showing errors or success messages
  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          message,
          style: TextStyle(color: AppColors.whiteSccafold),
        )));
  }

  static void navigateTo(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static void navigateToReplacement(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static void navigateToAndRemoveUntil(
      BuildContext context, Widget destination) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
