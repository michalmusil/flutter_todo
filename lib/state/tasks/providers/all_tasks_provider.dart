import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';
import 'package:todo_list/state/tasks/providers/tasks_repository_provider.dart';

final allTasksProvider = StreamProvider.autoDispose<Iterable<TaskModel>>(
  (ref) {
    final loggedInUser = ref.watch(userProvider);
    final tasksRepository = ref.watch(tasksRepositoryProvider);

    final controller = StreamController<Iterable<TaskModel>>();
    controller.sink.add([]);

    final subscription = loggedInUser != null
        ? tasksRepository.tasksStream(userId: loggedInUser.uuid).listen(
            (tasks) {
              controller.sink.add(tasks);
            },
          )
        : null;

    ref.onDispose(() {
      controller.close();
      subscription?.cancel();
    });
    return controller.stream;
  },
);
