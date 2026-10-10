import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_utils.dart';
import '../viewmodels/task_viewmodel.dart';
import 'widgets/app_text_field.dart';
import 'widgets/date_field.dart';
import 'widgets/error_text.dart';
import 'widgets/primary_button.dart';
import 'widgets/priority_selector.dart';

class TaskFormView extends StatelessWidget {
  const TaskFormView({super.key});

  Future<void> _pickDate(BuildContext context, TaskViewModel viewModel) async {
    final today = AppDateUtils.dateOnly(DateTime.now());
    final initialDate = viewModel.selectedDate.value ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // Allow past dates when editing an older task
      firstDate: initialDate.isBefore(today) ? initialDate : today,
      lastDate: DateTime(today.year + 5),
    );
    if (picked != null) viewModel.setDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TaskViewModel>();
    final task = Get.arguments as TaskModel?;
    final isEditing = task != null;
    final labelStyle = Theme.of(context).textTheme.titleSmall;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit task' : 'New task')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Title',
                      hint: 'What do you need to do?',
                      controller: viewModel.titleController,
                      maxLength: 100,
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      label: 'Description',
                      hint: 'Add some details (optional)',
                      controller: viewModel.descriptionController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    Text('Due date', style: labelStyle),
                    const SizedBox(height: 8),
                    Obx(
                      () => DateField(
                        date: viewModel.selectedDate.value,
                        onTap: () => _pickDate(context, viewModel),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Priority', style: labelStyle),
                    const SizedBox(height: 8),
                    Obx(
                      () => PrioritySelector(
                        selected: viewModel.selectedPriority.value,
                        onChanged: viewModel.setPriority,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  Obx(() => ErrorText(message: viewModel.formError.value)),
                  Obx(
                    () => PrimaryButton(
                      text: 'Save',
                      isLoading: viewModel.isSaving.value,
                      onPressed: viewModel.saveTask,
                    ),
                  ),
                  if (isEditing)
                    TextButton.icon(
                      onPressed: viewModel.deleteEditingTask,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete task'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
