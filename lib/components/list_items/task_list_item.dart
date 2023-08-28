import 'package:flutter/material.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/utils/datetime_utils.dart';

import '../../navigation/nav_router.dart';
import '../popups/confirmation_popup.dart';

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  final void Function() onClick;

  const TaskListItem({super.key, required this.task, required this.onClick});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  late final ITasksRepository _tasksRepository;
  late bool _isChecked;

  @override
  void initState() {
    _tasksRepository = TasksRepositoryImpl();
    _isChecked = widget.task.done;
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant TaskListItem oldWidget) {
    _isChecked = widget.task.done;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onCompletedChanged(bool newValue) {
    widget.task.done = newValue;
    _tasksRepository.updateTask(widget.task);
    setState(() {
      _isChecked = newValue;
    });
  }

  _deleteTask(BuildContext context) async {
    await _tasksRepository.deleteTask(widget.task);
  }

  Widget _deleteBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      color: Theme.of(context).colorScheme.error,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          "Delete",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.uuid),
      direction: DismissDirection.endToStart,
      background: _deleteBackground(context),
      secondaryBackground: _deleteBackground(context),
      onDismissed: (direction) {
        _deleteTask(context);
      },
      child: GestureDetector(
        onTap: widget.onClick,
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
                    _onCompletedChanged(valueToSet);
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
                        widget.task.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.task.due != null)
                        Text(
                          DateTimeUtils.getDateString(widget.task.due!),
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
