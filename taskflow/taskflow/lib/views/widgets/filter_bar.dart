import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/task_model.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/task_viewmodel.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  static const Map<String, String> _statusOptions = {
    'all': 'All',
    'active': 'Active',
    'completed': 'Completed',
  };

  static const Map<Priority?, String> _priorityOptions = {
    null: 'All',
    Priority.low: 'Low',
    Priority.medium: 'Medium',
    Priority.high: 'High',
  };

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TaskViewModel>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterRow(
            label: 'Status',
            chips: _statusOptions.entries
                .map(
                  (entry) => _FilterChip(
                    text: entry.value,
                    isSelected: viewModel.statusFilter.value == entry.key,
                    onSelected: () => viewModel.setStatusFilter(entry.key),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          _FilterRow(
            label: 'Priority',
            chips: _priorityOptions.entries
                .map(
                  (entry) => _FilterChip(
                    text: entry.value,
                    isSelected: viewModel.priorityFilter.value == entry.key,
                    onSelected: () => viewModel.setPriorityFilter(entry.key),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String label;
  final List<Widget> chips;

  const _FilterRow({required this.label, required this.chips});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(spacing: 8, children: chips),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.text,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(text),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
