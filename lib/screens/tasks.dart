import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/list_items/task_list_item.dart';
import 'package:todo_list/state/tasks/providers/task_list_provider.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';

class Tasks extends ConsumerWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

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
        title: const Text('Your tasks'),
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
                  "Logout",
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
                // TODO: Implement empty list screen
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "You don't have any tasks yet. Add some by clicking the plus button.",
                      textAlign: TextAlign.center,
                    ),
                  ),
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
            error: (error, stackTrace) {
              // TODO: Implement an error screen
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Something went wrong.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            loading: () {
              // TODO: Implement a loading screen
              return const Center(
                child: CircularProgressIndicator(),
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
