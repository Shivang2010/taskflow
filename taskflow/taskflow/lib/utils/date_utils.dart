import 'package:intl/intl.dart';

class AppDateUtils {
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String groupLabel(DateTime date, {DateTime? now}) {
    final today = dateOnly(now ?? DateTime.now());
    final difference = dateOnly(date).difference(today).inDays;
    if (difference < 0) return 'Overdue';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return 'Upcoming';
  }

  static bool isOverdue(DateTime date, {DateTime? now}) =>
      groupLabel(date, now: now) == 'Overdue';

  static String formatShort(DateTime date) => DateFormat('d MMM').format(date);

  static String formatHeader(DateTime date) =>
      'Today, ${DateFormat('d MMMM').format(date)}';
}
