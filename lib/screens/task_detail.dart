import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/content/item_detail.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/components/popups/confirmation_popup.dart';
import 'package:todo_list/state/tasks/providers/task_repo_state_provider.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/utils/datetime_utils.dart';
import 'package:todo_list/utils/localization_utils.dart';

import '../state/tasks/models/task_model.dart';

class TaskDetail extends ConsumerWidget {
  final TaskModel task;

  const TaskDetail({
    super.key,
    required this.task,
  });

  Widget get checkmark {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(
          width: 7,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        title: Text(
          strings(context).taskDetail,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            NavRouter.instance().returnBack(context);
          },
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationPopup(
                      title: strings(context).deleteTask,
                      message:
                          strings(context).sureToDeleteTask,
                      onConfirm: () async {
                        final taskRepoStateNotifier = ref.read(taskRepoStateProvider.notifier);
                        await taskRepoStateNotifier
                            .deleteTask(
                              task: task,
                            )
                            .then((_) {
                              NavRouter.instance().returnBack(context);
                            });
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 26.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (task.done == true) checkmark,
                  Expanded(
                    child: Text(
                      task.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              if (task.description != null)
                Column(
                  children: [
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ItemDetail(
                  label: strings(context).created,
                  values: [
                    DateTimeUtils.getDateString(task.created),
                    DateTimeUtils.getTimeString(task.created),
                  ],
                  icon: Icons.calendar_month_rounded),
              if (task.due != null)
                ItemDetail(
                  label: strings(context).due,
                  values: [
                    DateTimeUtils.getDateString(task.due!),
                    DateTimeUtils.getTimeString(task.due!),
                  ],
                  icon: Icons.timelapse_rounded,
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundedPushButton(
                    text: strings(context).edit,
                    icon: Icons.edit,
                    onClick: () {
                      NavRouter.instance().toTaskCreateOrUpdate(
                        context,
                        task: task,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
