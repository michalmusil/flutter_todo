import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/locator.dart';
import 'package:todo_list/presentation/bloc/task_list/task_list_cubit.dart';
import 'package:todo_list/presentation/components/content/live_task_list_view.dart';
import 'package:todo_list/presentation/components/decorative/error_banner.dart';
import 'package:todo_list/presentation/components/overlay/loading_overlay.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/utils/localization_utils.dart';

class Tasks extends StatelessWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListCubit(
        tasksRepository: locator<TasksRepositoryBase>(),
        authService: locator<AuthServiceBase>(),
      ),
      child: DefaultTabController(
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
              BlocBuilder<TaskListCubit, TaskListState>(
                builder: (context, state) {
                  final cubit = BlocProvider.of<TaskListCubit>(context);

                  return TextButton(
                    onPressed: () {
                      cubit.logOut();
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
          body: BlocConsumer<TaskListCubit, TaskListState>(
            listener: (context, state) {
              switch (state) {
                case TaskListLoading():
                  {
                    LoadingOverlay.instance().show(context);
                    break;
                  }
                case TaskListLoggedOut():
                  {
                    LoadingOverlay.instance().hide();
                    NavRouter.instance().toLogin(context);
                    break;
                  }
                default:
                  {
                    LoadingOverlay.instance().hide();
                    break;
                  }
              }
            },
            builder: (context, state) {
              switch (state) {
                case TaskListError():
                  return ErrorBanner(
                    text: strings(context).somethingWentWrong,
                  );
                case TaskListLoaded(
                    allTasks: final all,
                    dueTasks: final due,
                    doneTasks: final done
                  ):
                  return TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LiveTaskListView(
                        tasksStream: all,
                        onEmptyListText: strings(context).noTasks,
                      ),
                      LiveTaskListView(
                        tasksStream: due,
                        onEmptyListText: strings(context).noDueTasks,
                      ),
                      LiveTaskListView(
                        tasksStream: done,
                        onEmptyListText: strings(context).noDoneTasks,
                      ),
                    ],
                  );
                default:
                  return const SizedBox();
              }
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
        ),
      ),
    );
  }
}
