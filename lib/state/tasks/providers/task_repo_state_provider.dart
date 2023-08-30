import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/tasks/notifiers/task_repo_notifier.dart';
import 'package:todo_list/state/tasks/providers/tasks_repository_provider.dart';

final taskRepoStateProvider =
    StateNotifierProvider<TaskRepoNotifier, TaskRepoState>(
  (ref) {
    final tasksRepository = ref.watch(tasksRepositoryProvider);
    
    return TaskRepoNotifier(
      repository: tasksRepository,
    );
  },
);
