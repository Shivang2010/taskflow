import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_colors.dart';
import '../utils/date_utils.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/task_viewmodel.dart';
import 'widgets/empty_state.dart';
import 'widgets/filter_bar.dart';
import 'widgets/task_card.dart';
import 'widgets/task_list_header.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  void _openForm(TaskViewModel viewModel, TaskModel? task) {
    viewModel.loadTask(task);
    Get.toNamed(AppRoutes.taskForm, arguments: task);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TaskViewModel>();
    final authViewModel = Get.find<AuthViewModel>();

    return Scaffold(
      body: Column(
        children: [
          TaskListHeader(onLogout: authViewModel.logout),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: FilterBar(),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: _TaskList(
                viewModel: viewModel,
                onOpenTask: (task) => _openForm(viewModel, task),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () => _openForm(viewModel, null),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        height: 56,
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final TaskViewModel viewModel;
  final ValueChanged<TaskModel> onOpenTask;

  const _TaskList({required this.viewModel, required this.onOpenTask});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (viewModel.tasks.isEmpty) {
        return const EmptyState(
          icon: Icons.checklist_rounded,
          message: 'No tasks yet. Tap + to add one.',
        );
      }
      final tasks = viewModel.filteredTasks;
      if (tasks.isEmpty) {
        return EmptyState(
          icon: Icons.filter_alt_off_outlined,
          message: 'No tasks match these filters',
          action: TextButton(
            onPressed: viewModel.clearFilters,
            child: const Text('Clear filters'),
          ),
        );
      }

      // Tasks are sorted by date, so a header is added whenever the group changes
      final items = <Widget>[];
      String? currentGroup;
      for (final task in tasks) {
        final group = AppDateUtils.groupLabel(task.dueDate);
        if (group != currentGroup) {
          currentGroup = group;
          items.add(_GroupHeader(label: group));
        }
        items.add(_buildDismissibleCard(task));
      }
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: items,
      );
    });
  }

  Widget _buildDismissibleCard(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => viewModel.confirmDelete(),
        onDismissed: (_) => viewModel.deleteTask(task),
        background: const _DeleteBackground(),
        child: TaskCard(
          task: task,
          onTap: () => onOpenTask(task),
          onToggleComplete: () => viewModel.toggleComplete(task),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String label;

  const _GroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: label == 'Overdue' ? AppColors.error : null,
        ),
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.error,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
    );
  }
}
