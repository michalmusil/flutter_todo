import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/tasks/repositories/tasks_repository.dart';
import 'package:todo_list/state/tasks/repositories/tasks_repository_base.dart';

final tasksRepositoryProvider = Provider<TasksRepositoryBase>(
  (ref) {
    return TasksRepository();
  },
);
