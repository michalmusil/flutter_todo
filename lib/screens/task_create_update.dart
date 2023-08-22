import 'package:flutter/material.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';

import '../model/tasks/task_model.dart';
import '../navigation/nav_router.dart';

class TaskCreateUpdate extends StatefulWidget {
  const TaskCreateUpdate({super.key, this.task});

  final TaskModel? task;

  @override
  State<TaskCreateUpdate> createState() => _TaskCreateUpdateState();
}

class _TaskCreateUpdateState extends State<TaskCreateUpdate> {
  late final ITasksRepository _tasksRepository;
  late final TaskModel? _existingTask;
  late final bool _isUpdating;

  @override
  void initState() {
    _tasksRepository = TasksRepositoryImpl();
    _existingTask = widget.task;
    _isUpdating = _existingTask != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Expanded(
          child: Text(
            (_isUpdating == true ? "Update task" : "Add task"),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            NavRouter.instance.returnBack(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                // TODO()
              },
              icon: Icon(
                Icons.delete_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 26.0,
          ),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
