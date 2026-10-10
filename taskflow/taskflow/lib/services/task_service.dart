import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _tasksRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('tasks');

  Stream<List<TaskModel>> getTasks(String uid) {
    return _tasksRef(uid)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addTask(String uid, TaskModel task) async {
    await _tasksRef(
      uid,
    ).add({...task.toMap(), 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateTask(String uid, TaskModel task) async {
    await _tasksRef(uid).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _tasksRef(uid).doc(taskId).delete();
  }

  Future<void> toggleComplete(String uid, TaskModel task) async {
    await _tasksRef(
      uid,
    ).doc(task.id).update({'isCompleted': !task.isCompleted});
  }
}
