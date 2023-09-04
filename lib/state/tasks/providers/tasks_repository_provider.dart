import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/data/repositories/tasks_repository.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';

final tasksRepositoryProvider = Provider<TasksRepositoryBase>(
  (ref) {
    return TasksRepository();
  },
);
