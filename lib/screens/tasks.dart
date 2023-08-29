import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/list_items/task_list_item.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_notifier_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';

class Tasks extends ConsumerWidget {
  final ITasksRepository _tasksRepository = TasksRepositoryImpl();

  Tasks({super.key});

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
          NavRouter.instance.toLogin(context);
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
              final authNotifier = ref.read(authNotifierProvider.notifier);

              return TextButton(
                onPressed: () {
                  authNotifier.logOut();
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
      body: StreamBuilder(
        stream: _tasksRepository.tasksStream(),
        builder: (context, snapshot) {
          var newList = snapshot.data;
          if (newList == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (newList.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "You don't have any tasks yet. Add some by clicking the plus button.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: newList.length,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            itemBuilder: (context, index) {
              return TaskListItem(
                task: newList[index],
                onClick: () {
                  NavRouter.instance.toTaskDetail(
                    context,
                    task: newList[index],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavRouter.instance.toTaskCreateOrUpdate(
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
