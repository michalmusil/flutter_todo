import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/content/live_task_list_view.dart';
import 'package:todo_list/components/decorative/loading_banner.dart';
import 'package:todo_list/components/decorative/no_content_banner.dart';
import 'package:todo_list/components/list_items/task_list_item.dart';
import 'package:todo_list/state/tasks/providers/all_tasks_provider.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/state/tasks/providers/done_tasks_provider.dart';
import 'package:todo_list/state/tasks/providers/due_tasks_provider.dart';
import 'package:todo_list/utils/localization_utils.dart';

class Tasks extends ConsumerWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      userProvider,
      (previous, currentUser) {
        if (currentUser == null) {
          NavRouter.instance().toLogin(context);
        }
      },
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings(context).yourTasks),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  strings(context).allTasks,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              Tab(
                child: Text(
                  strings(context).dueTasks,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              Tab(
                child: Text(
                  strings(context).doneTasks,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ],
          ),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                return TextButton(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logOut();
                  },
                  child: Text(
                    strings(context).logout,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            LiveTaskListView(
              tasksProvider: allTasksProvider,
              onEmptyListText: strings(context).noTasks,
            ),
            LiveTaskListView(
              tasksProvider: dueTasksProvider,
              onEmptyListText: strings(context).noDueTasks,
            ),
            LiveTaskListView(
              tasksProvider: doneTasksProvider,
              onEmptyListText: strings(context).noDoneTasks,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NavRouter.instance().toTaskCreateOrUpdate(
              context,
              task: null,
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
