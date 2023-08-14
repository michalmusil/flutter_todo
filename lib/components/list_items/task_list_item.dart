import 'package:flutter/material.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/utils/datetime_utils.dart';

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  final void Function() onClick;

  const TaskListItem({super.key, required this.task, required this.onClick});

  @override
  State<TaskListItem> createState() => _TaskListItemState(task, onClick);
}

class _TaskListItemState extends State<TaskListItem> {
  final TaskModel _task;
  final void Function() _onClick;
  late final ITasksRepository _tasksRepository;
  late bool _isChecked;

  _TaskListItemState(this._task, this._onClick);

  void delete() {}

  @override
  void initState() {
    _tasksRepository = TasksRepositoryImpl();
    _isChecked = _task.done;
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

  void onCompletedChanged(bool newValue) {
    _task.done = newValue;
    _tasksRepository.updateTask(_task);
    setState(() {
      _isChecked = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  final valueToSet = value ?? _isChecked;
                  onCompletedChanged(valueToSet);
                },
                activeColor: Theme.of(context).colorScheme.secondary,
                checkColor: Theme.of(context).colorScheme.onSecondary,
                shape: const CircleBorder(),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _task.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_task.due != null)
                      Text(
                        DateTimeUtils.getDateString(_task.due!),
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 40,
                  maxWidth: 40,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: IconButton(
                  onPressed: () {
                    delete();
                  },
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Theme.of(context).colorScheme.onError,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
