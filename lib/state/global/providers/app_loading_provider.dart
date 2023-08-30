import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/providers/auth_loading_provider.dart';
import 'package:todo_list/state/tasks/providers/task_repo_state_provider.dart';

final appLoadingProvider = Provider<bool>(
  (ref) {
    final authIsLoading = ref.watch(authLoadingProvider);
    final taskRepoIsLoading = ref.watch(taskRepoStateProvider);

    return authIsLoading || taskRepoIsLoading;
  },
);
