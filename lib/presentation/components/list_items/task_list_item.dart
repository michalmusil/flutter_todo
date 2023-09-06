import 'package:flutter/material.dart';
import 'package:todo_list/locator.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';
import 'package:todo_list/domain/models/task/task_model.dart';
import 'package:todo_list/utils/datetime_utils.dart';
import 'package:todo_list/utils/localization_utils.dart';

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  final void Function() onClick;
  final void Function(bool)? onDoneStateChanged;
  final BorderRadius edgeRadius = BorderRadius.circular(8);
  final EdgeInsets itemMargin = const EdgeInsets.symmetric(vertical: 5);

  TaskListItem({
    super.key,
    required this.task,
    required this.onClick,
    this.onDoneStateChanged,
  });

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  final TasksRepositoryBase _repository = locator<TasksRepositoryBase>();
  late bool _isChecked;

  @override
  void initState() {
    _isChecked = widget.task.done;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskListItem oldWidget) {
    _isChecked = widget.task.done;
    super.didUpdateWidget(oldWidget);
  }

  _onCompletedChanged({
    required bool newValue,
  }) {
    widget.task.done = newValue;
    _repository.updateTask(widget.task);
    setState(() {
      _isChecked = newValue;
    });
    if (widget.onDoneStateChanged != null) {
      widget.onDoneStateChanged!(newValue);
    }
  }

  _deleteTask({
    required BuildContext context,
  }) async {
    await _repository.deleteTask(widget.task);
  }

  Widget _deleteBackground(BuildContext context) {
    return Padding(
      padding: widget.itemMargin,
      child: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: widget.edgeRadius,
        ),
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
      ),
    );
  }

  Widget _doneCheckbox({
    required BuildContext context,
  }) {
    return Checkbox(
      value: _isChecked,
      onChanged: (value) {
        final valueToSet = value ?? _isChecked;
        _onCompletedChanged(
          newValue: valueToSet,
        );
      },
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.onPrimary,
      shape: const CircleBorder(),
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.id),
      direction: DismissDirection.endToStart,
      background: _deleteBackground(context),
      secondaryBackground: _deleteBackground(context),
      onDismissed: (direction) {
        _deleteTask(
          context: context,
        );
      },
      child: GestureDetector(
        onTap: widget.onClick,
        child: Container(
          margin: widget.itemMargin,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: widget.edgeRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _doneCheckbox(
                  context: context,
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
  }
}
