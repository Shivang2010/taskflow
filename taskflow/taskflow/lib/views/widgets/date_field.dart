import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/date_utils.dart';

class DateField extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;

  const DateField({super.key, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.calendar_today_outlined, size: 20),
        ),
        child: Text(
          date == null ? 'Pick a date' : AppDateUtils.formatShort(date!),
          style: TextStyle(
            color: date == null ? AppColors.textGrey : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
