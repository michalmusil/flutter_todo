import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/tasks/providers/tasks_repository_provider.dart';
import 'package:todo_list/state/tasks/repositories/tasks_repository_base.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';
import 'package:todo_list/utils/datetime_utils.dart';
import 'package:todo_list/utils/localization_utils.dart';

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  final void Function() onClick;

  const TaskListItem({super.key, required this.task, required this.onClick});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  late bool _isChecked;

  @override
  void initState() {
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
  
  _onCompletedChanged({
    required bool newValue,
    required TasksRepositoryBase repository,
  }) {
    widget.task.done = newValue;
    repository.updateTask(widget.task);
    setState(() {
      _isChecked = newValue;
    });
  }

  _deleteTask({
    required BuildContext context,
    required TasksRepositoryBase repository,
  }) async {
    await repository.deleteTask(widget.task);
  }

  Widget _deleteBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      color: Theme.of(context).colorScheme.error,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          strings(context).delete,
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
    return Consumer(
      builder: (context, ref, child) {
        final tasksRepository = ref.watch(tasksRepositoryProvider);

        return Dismissible(
          key: Key(widget.task.id),
          direction: DismissDirection.endToStart,
          background: _deleteBackground(context),
          secondaryBackground: _deleteBackground(context),
          onDismissed: (direction) {
            _deleteTask(
              context: context,
              repository: tasksRepository,
            );
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
                        _onCompletedChanged(
                          newValue: valueToSet,
                          repository: tasksRepository,
                        );
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      checkColor: Theme.of(context).colorScheme.onPrimary,
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
                            const SizedBox(
                              height: 5,
                            ),
                          if (widget.task.due != null)
                            Text(
                              DateTimeUtils.getDateString(widget.task.due!),
                              style: Theme.of(context).textTheme.labelMedium,
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
      },
    );
  }
}
