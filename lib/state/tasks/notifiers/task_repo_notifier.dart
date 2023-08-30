import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';
import 'package:todo_list/state/tasks/repositories/tasks_repository_base.dart';

typedef TaskRepoState = bool;

// State of the notifier represents loading while any method is being completed
class TaskRepoNotifier extends StateNotifier<TaskRepoState> {
  late final TasksRepositoryBase _repository;

  set isLoading(TaskRepoState value) {
    state = value;
  }

  TaskRepoNotifier({
    required TasksRepositoryBase repository,
  }) : super(false){
    _repository = repository;
  }

  Future<TaskModel?> getTask({required String userId, required String taskId}) async{
    isLoading = true;
    final task = await _repository.taskStatic(userId: userId, taskId: taskId);
    isLoading = false;
    return task;
  }

  Future<Iterable<TaskModel?>> getTasks({required String userId}) async{
    isLoading = true;
    final tasks = await _repository.tasksStatic(userId: userId);
    isLoading = false;
    return tasks;
  }

  Future<bool> addTask({required String userId, required TaskModel task}) async{
    isLoading = true;
    final created = await _repository.addTask(userId: userId, task: task);
    isLoading = false;
    return created;
  }

  Future<bool> updateTask({required TaskModel task}) async{
    isLoading = true;
    final updated = await _repository.updateTask(task);
    isLoading = false;
    return updated;
  }

  Future<bool> deleteTask({required TaskModel task}) async{
    isLoading = true;
    final deleted = await _repository.deleteTask(task);
    isLoading = false;
    return deleted;
  }
}
