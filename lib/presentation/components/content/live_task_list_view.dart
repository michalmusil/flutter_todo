import 'package:flutter/material.dart';
import 'package:todo_list/presentation/components/decorative/error_banner.dart';
import 'package:todo_list/presentation/components/decorative/no_content_banner.dart';
import 'package:todo_list/presentation/components/list_items/task_list_item.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/domain/models/task/task_model.dart';
import 'package:todo_list/utils/localization_utils.dart';

class LiveTaskListView extends StatelessWidget {
  final Stream<Iterable<TaskModel>> tasksStream;
  final String? onEmptyListText;
  final String? onLoadingText;
  final String? onErrorText;

  const LiveTaskListView({
    super.key,
    required this.tasksStream,
    this.onEmptyListText,
    this.onLoadingText,
    this.onErrorText,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tasksStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorBanner(
            text: onErrorText ?? strings(context).somethingWentWrong,
          );
        }
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        if (snapshot.data!.isEmpty) {
          return NoContentBanner(
            text: onEmptyListText ?? strings(context).noTasks,
          );
        }

        final list = snapshot.data!;
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
      },
    );
  }
}
