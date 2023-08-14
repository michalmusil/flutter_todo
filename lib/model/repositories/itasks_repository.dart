import '../tasks/task_model.dart';

abstract class ITasksRepository{
  Stream<List<TaskModel>> tasksStream();

  Stream<TaskModel?> taskStream(String taskUuid);

  Future<List<TaskModel>> tasksStatic();

  Future<TaskModel?> taskStatic(String taskUuid);

  Future<bool> addTask(TaskModel task);

  Future<bool> updateTask(TaskModel task);

  Future<bool> deleteTask(TaskModel task);
}