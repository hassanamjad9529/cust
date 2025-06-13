
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateRangeWithDaysWidget extends StatelessWidget {
  final String? startDate;
  final String? endDate;

  const DateRangeWithDaysWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  String _formatDays(DateTime? start, DateTime? end) {
    if (start == null) return '';

    if (end == null || start.isAtSameMomentAs(end)) {
      return DateFormat('EEEE').format(start); // Monday
    }

    Duration diff = end.difference(start);
    if (diff.inDays <= 3) {
      List<String> days = [];
      for (int i = 0; i <= diff.inDays; i++) {
        days.add(DateFormat('EEEE').format(start.add(Duration(days: i))));
      }
      return days.join(' - ');
    } else {
      return '${DateFormat('EEEE').format(start)} - ${DateFormat('EEEE').format(end)}';
    }
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null) return '';

    if (end == null || start.isAtSameMomentAs(end)) {
      return DateFormat('MMMM d, y').format(start); // April 25, 2025
    }
    if (start.month == end.month && start.year == end.year) {
      return '${DateFormat('MMMM d').format(start)} - ${DateFormat('d, y').format(end)}';
    }
    return '${DateFormat('MMMM d, y').format(start)} - ${DateFormat('MMMM d, y').format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? start = _parseDate(startDate);
    final DateTime? end = _parseDate(endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatDays(start, end),
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(
          _formatDateRange(start, end),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
