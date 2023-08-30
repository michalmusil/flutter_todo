import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/decorative/error_banner.dart';
import 'package:todo_list/components/decorative/loading_banner.dart';
import 'package:todo_list/components/decorative/no_content_banner.dart';
import 'package:todo_list/components/list_items/task_list_item.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';
import 'package:todo_list/utils/localization_utils.dart';

class LiveTaskListView extends ConsumerWidget {
  final AutoDisposeStreamProvider<Iterable<TaskModel>> tasksProvider;
  final String? onEmptyListText;
  final String? onLoadingText;
  final String? onErrorText;

  const LiveTaskListView({
    super.key,
    required this.tasksProvider,
    this.onEmptyListText,
    this.onLoadingText,
    this.onErrorText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksStream = ref.watch(tasksProvider);

    return tasksStream.when(
      data: (list) {
        if (list.isEmpty) {
          return NoContentBanner(
            text: onEmptyListText ?? strings(context).noTasks,
          );
        } else {
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            itemBuilder: (context, index) {
              return TaskListItem(
                task: list.elementAt(index),
                onClick: () {
                  NavRouter.instance().toTaskDetail(
                    context,
                    task: list.elementAt(index),
                  );
                },
              );
            },
          );
        }
      },
      loading: () {
        return LoadingBanner(
          loadingText: onLoadingText ?? strings(context).loading,
        );
      },
      error: (error, stackTrace) {
        return ErrorBanner(
          text: onErrorText ?? strings(context).somethingWentWrong,
        );
      },
    );
  }
}
