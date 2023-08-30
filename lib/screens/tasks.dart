import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/decorative/loading_banner.dart';
import 'package:todo_list/components/decorative/no_content_banner.dart';
import 'package:todo_list/components/list_items/task_list_item.dart';
import 'package:todo_list/state/tasks/providers/task_list_provider.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(strings(context).yourTasks),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
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
      body: Consumer(
        builder: (context, ref, child) {
          final tasksStream = ref.watch(taskListProvider);

          return tasksStream.when(
            data: (list) {
              if (list.isEmpty) {
                return NoContentBanner(
                  text: strings(context).noTasks,
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
                loadingText: strings(context).loading,
              );
            },
            error: (error, stackTrace) {
              // TODO: Implement an error screen
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    strings(context).somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          );
        },
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
    );
  }
}
