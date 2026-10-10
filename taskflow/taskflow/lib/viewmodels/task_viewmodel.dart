import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../utils/validators.dart';

class TaskViewModel extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final TaskService _taskService = TaskService();

  final tasks = <TaskModel>[].obs;
  final isLoading = true.obs;
  final statusFilter = 'all'.obs;
  final priorityFilter = Rxn<Priority>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedDate = Rxn<DateTime>();
  final selectedPriority = Priority.medium.obs;
  final formError = ''.obs;
  final isSaving = false.obs;
  TaskModel? _editingTask;

  String get _uid => _authService.currentUser!.uid;

  bool get hasFilters =>
      statusFilter.value != 'all' || priorityFilter.value != null;

  List<TaskModel> get filteredTasks {
    final result = tasks.where((task) {
      if (statusFilter.value == 'active' && task.isCompleted) return false;
      if (statusFilter.value == 'completed' && !task.isCompleted) return false;
      if (priorityFilter.value != null &&
          task.priority != priorityFilter.value) {
        return false;
      }
      return true;
    }).toList();
    result.sort((a, b) {
      final byDate = a.dueDate.compareTo(b.dueDate);
      if (byDate != 0) return byDate;
      // Same day: higher priority first
      return b.priority.index.compareTo(a.priority.index);
    });
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    ever(tasks, (_) => isLoading.value = false);
    tasks.bindStream(
      _taskService.getTasks(_uid).handleError((Object error) {
        isLoading.value = false;
        // The stream errors with permission-denied right after logout; ignore that case
        if (_authService.currentUser != null) {
          Get.snackbar('Error', 'Could not load your tasks.');
        }
      }),
    );
  }

  void setStatusFilter(String value) => statusFilter.value = value;

  void setPriorityFilter(Priority? value) => priorityFilter.value = value;

  void clearFilters() {
    statusFilter.value = 'all';
    priorityFilter.value = null;
  }

  void loadTask(TaskModel? task) {
    _editingTask = task;
    titleController.text = task?.title ?? '';
    descriptionController.text = task?.description ?? '';
    selectedDate.value = task?.dueDate;
    selectedPriority.value = task?.priority ?? Priority.medium;
    formError.value = '';
  }

  void setDate(DateTime date) => selectedDate.value = date;

  void setPriority(Priority priority) => selectedPriority.value = priority;

  Future<void> saveTask() async {
    final titleError = Validators.validateTitle(titleController.text);
    if (titleError != null) {
      formError.value = titleError;
      return;
    }
    if (selectedDate.value == null) {
      formError.value = 'Please pick a due date';
      return;
    }

    formError.value = '';
    isSaving.value = true;
    final task = TaskModel(
      id: _editingTask?.id ?? '',
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: selectedDate.value!,
      priority: selectedPriority.value,
      isCompleted: _editingTask?.isCompleted ?? false,
      createdAt: _editingTask?.createdAt,
    );
    try {
      if (_editingTask == null) {
        await _taskService.addTask(_uid, task);
      } else {
        await _taskService.updateTask(_uid, task);
      }
      Get.back();
      Get.snackbar('Saved', 'Your task has been saved.');
    } catch (_) {
      formError.value = 'Could not save the task. Please try again.';
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> confirmDelete() async {
    final result = await Get.defaultDialog<bool>(
      title: 'Delete task',
      middleText: 'Are you sure you want to delete this task?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
    );
    return result ?? false;
  }

  Future<void> deleteTask(TaskModel task) async {
    // Remove locally first so the dismissed card leaves the list right away
    tasks.removeWhere((item) => item.id == task.id);
    try {
      await _taskService.deleteTask(_uid, task.id);
    } catch (_) {
      Get.snackbar('Error', 'Could not delete the task.');
    }
  }

  Future<void> deleteEditingTask() async {
    final task = _editingTask;
    if (task == null || !await confirmDelete()) return;
    Get.back();
    await deleteTask(task);
  }

  Future<void> toggleComplete(TaskModel task) async {
    try {
      await _taskService.toggleComplete(_uid, task);
    } catch (_) {
      Get.snackbar('Error', 'Could not update the task.');
    }
  }

  @override
  void onClose() {
    tasks.close();
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
