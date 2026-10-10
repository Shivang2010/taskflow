import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { low, medium, high }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  final bool isCompleted;
  final DateTime? createdAt;

  const TaskModel({
    this.id = '',
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
    this.createdAt,
  });

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      priority: Priority.values.asNameMap()[map['priority']] ?? Priority.medium,
      isCompleted: map['isCompleted'] as bool? ?? false,
      // createdAt is null until the server timestamp arrives
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // createdAt is left out on purpose; TaskService sets it once on create
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.name,
      'isCompleted': isCompleted,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
