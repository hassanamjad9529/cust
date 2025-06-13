import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension MediaQueryValues on BuildContext {
  double get mediaQueryHeight => MediaQuery.sizeOf(this).height;
  double get mediaQueryWidth => MediaQuery.sizeOf(this).width;
}

extension EmptySpace on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
}

extension NumberFormatter on num {
  /// Converts a number into a short readable format, e.g. 1k, 1.2M, etc.
  String get viewCountFormatted {
    if (this >= 1000000000) {
      return "${(this / 1000000000).toStringAsFixed(1)}B"; // Billions
    } else if (this >= 1000000) {
      return "${(this / 1000000).toStringAsFixed(1)}M"; // Millions
    } else if (this >= 1000) {
      return "${(this / 1000).toStringAsFixed(1)}k"; // Thousands
    } else {
      return toString(); // Less than 1000, no formatting
    }
  }
}

extension DateTimeFormatter on String {
  String toFormattedDate() {
    if (isEmpty) return "N/A";
    DateTime? date = DateTime.tryParse(this);
    if (date == null) return "Invalid Date";

    return "${date.day}, ${_getMonthName(date.month)} ${date.year}";
  }

  static String _getMonthName(int month) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return monthNames[month - 1];
  }
}

/// this will return year only
extension DateTimeYearFormatter on String {
  String toYearOnly() {
    if (isEmpty) return "N/A";
    DateTime? date = DateTime.tryParse(this);
    if (date == null) return "Invalid Date";

    return "${date.year}";
  }

  String toDateAndMonth() {
    if (isEmpty) return "N/A";
    DateTime? date = DateTime.tryParse(this);
    if (date == null) return "Invalid Date";

    return "${date.day} ${_getMonthName(date.month)}";
  }

  static String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return monthNames[month - 1];
  }
}

extension DateTimeFormatExtension on DateTime {
  String toCustomString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    // If it's today
    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(this); // Time format with AM/PM
    }

    // If it's yesterday
    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    // Otherwise, format as dd/MM/yy (28/11/24)
    return DateFormat('dd/MM/yy').format(this);
  }
}

extension NameFormatter on String {
  String get formattedName {
    List<String> words = trim().split(' ');
    return words.length > 1 ? '${words[0]} ${words[1]}' : words[0];
  }
}

extension CapitalizeFirstLetter on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}

extension DateParser on dynamic {
  DateTime? toDateTime() {
    if (this == null) return null;
    if (this is DateTime) return this as DateTime;
    if (this is Timestamp) return (this as Timestamp).toDate();
    if (this is String) {
      try {
        return DateTime.parse(this as String);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return "${weekdayName(this.weekday)}, ${monthName(this.month)} ${this.day}, ${this.year}";
  }
}





String weekdayName(int weekday) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return days[weekday - 1];
}

String monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}


extension MonthExtensions on int {
  String toMonthName({bool abbreviated = false}) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const shortMonthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (this < 1 || this > 12) {
      return 'Invalid';
    }
    return abbreviated ? shortMonthNames[this - 1] : monthNames[this - 1];
  }
}