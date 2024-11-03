import 'package:flutter/material.dart';

extension ReadableDateTime on DateTime {
  /// Formats the DateTime instance to a readable string, e.g., "Oct 31, 2024 - 2:30 PM"
  String toReadableString(BuildContext context) {
    final date = '${_monthAbbreviation(month)} $day, $year';
    final time = TimeOfDay.fromDateTime(this).format(context);
    return '$date - $time';
  }

  /// Helper method to get the abbreviated month name
  String _monthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
