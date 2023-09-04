import '../models/task/task_model.dart';

abstract class TasksRepositoryBase {
  // If done is null, all tasks are fetched
  Stream<Iterable<TaskModel>> tasksStream({required String userId, bool? done});
  Future<Iterable<TaskModel>> tasksStatic({required String userId, bool? done});

  Stream<TaskModel?> taskStream({required String userId, required String taskId});
  Future<TaskModel?> taskStatic({required String userId, required String taskId});

  Future<bool> addTask({required String userId, required TaskModel task});

  Future<bool> updateTask(TaskModel task);

  Future<bool> deleteTask(TaskModel task);
}
