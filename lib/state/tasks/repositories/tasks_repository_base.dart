import '../models/task_model.dart';

abstract class TasksRepositoryBase {
  Stream<Iterable<TaskModel>> tasksStream({required String userId});

  Stream<TaskModel?> taskStream({required String userId, required String taskId});

  Future<Iterable<TaskModel>> tasksStatic({required String userId});

  Future<TaskModel?> taskStatic({required String userId, required String taskId});

  Future<bool> addTask({required String userId, required TaskModel task});

  Future<bool> updateTask(TaskModel task);

  Future<bool> deleteTask(TaskModel task);
}
