import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';

import 'tasks_repository_provider.dart';

final dueTasksProvider = StreamProvider.autoDispose<Iterable<TaskModel>>(
  (ref) {
    final userId = ref.watch(userProvider)?.uuid;
    final tasksRepository = ref.watch(tasksRepositoryProvider);

    final controller = StreamController<Iterable<TaskModel>>();
    controller.sink.add([]);

    final sub = userId != null
        ? tasksRepository
            .tasksStream(
              userId: userId,
              done: false,
            )
            .listen(
              (newList) {
                controller.sink.add(newList);
              },
            )
        : null;
    
    ref.onDispose(() {
      sub?.cancel();
      controller.close();
    });
    
    return controller.stream;
  },
);
