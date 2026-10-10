import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/task_model.dart';

void main() {
  test('toMap then fromMap returns the same values', () {
    final task = TaskModel(
      id: 'abc123',
      title: 'Buy groceries',
      description: 'Milk and eggs',
      dueDate: DateTime(2026, 5, 2),
      priority: Priority.high,
      isCompleted: true,
    );

    final result = TaskModel.fromMap(task.id, task.toMap());

    expect(result.id, task.id);
    expect(result.title, task.title);
    expect(result.description, task.description);
    expect(result.dueDate, task.dueDate);
    expect(result.priority, task.priority);
    expect(result.isCompleted, task.isCompleted);
  });

  test('missing priority falls back to medium', () {
    final map = TaskModel(title: 'Task', dueDate: DateTime(2026, 5, 2)).toMap()
      ..remove('priority');

    expect(TaskModel.fromMap('id', map).priority, Priority.medium);
  });
}
