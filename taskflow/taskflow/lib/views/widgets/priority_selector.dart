import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../utils/app_colors.dart';

class PrioritySelector extends StatelessWidget {
  final Priority selected;
  final ValueChanged<Priority> onChanged;

  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Priority.values.map((priority) {
        final isSelected = priority == selected;
        final label =
            priority.name[0].toUpperCase() + priority.name.substring(1);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onChanged(priority),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        );
      }).toList(),
    );
  }
}
