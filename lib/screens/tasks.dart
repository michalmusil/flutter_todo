import 'package:flutter/material.dart';
import 'package:todo_list/components/list_items/task_list_item.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/services/auth/auth_service_impl.dart';

import '../services/auth/iauth_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final IAuthService _authService;
  late final ITasksRepository _tasksRepository;
  // late List<TaskModel> _tasks = [];

  @override
  void initState() {
    _authService = AuthServiceImpl();
    _tasksRepository = TasksRepositoryImpl();
    // fetchTasks();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future fetchTasks() async {
  //   final tasks = await _tasksRepository.tasksStatic();
  //   setState(() {
  //     _tasks.clear();
  //     _tasks.addAll(tasks);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your tasks'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              _authService.logOut();
              NavRouter.instance.toLogin(context);
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _tasksRepository.tasksStream(),
        builder: (context, snapshot) {
          var newList = snapshot.data;
          if (newList == null) {
            return const Text("Loading");
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
