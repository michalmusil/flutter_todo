import 'package:flutter/material.dart';
import 'package:todo_list/components/decorative/item_detail.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/components/popups/confirmation_popup.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/utils/datetime_utils.dart';

import '../model/tasks/task_model.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late ITasksRepository _tasksRepository;
  late TaskModel _task;

  @override
  void initState() {
    _task = widget.task;
    _tasksRepository = TasksRepositoryImpl();
    super.initState();
  }

  _deleteTask(BuildContext context) async {
    var deleted = await _tasksRepository.deleteTask(_task);
    if (deleted) {
      NavRouter.instance.toTasks(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text(
          "Task detail",
          overflow: TextOverflow.ellipsis,
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
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationPopup(
                    title: "Delete task",
                    message:
                        "Are you sure you want to delete this task? This acction can't be undone.",
                    onConfirm: () {
                      _deleteTask(context);
                    },
                  ),
                );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_task.done == true) checkmark,
                  Expanded(
                    child: Text(
                      _task.name,
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
              if (_task.description != null)
                Column(
                  children: [
                    Text(
                      _task.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ItemDetail(
                  label: "Created",
                  values: [
                    DateTimeUtils.getDateString(_task.created),
                    DateTimeUtils.getTimeString(_task.created),
                  ],
                  icon: Icons.calendar_month_rounded),
              if (_task.due != null)
                ItemDetail(
                  label: "Due",
                  values: [
                    DateTimeUtils.getDateString(_task.due!),
                    DateTimeUtils.getTimeString(_task.due!),
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
                    text: "Edit",
                    icon: Icons.edit,
                    onClick: () {
                      NavRouter.instance
                          .toTaskCreateOrUpdate(context, task: _task);
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
}
