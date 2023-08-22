import 'package:flutter/material.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
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

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool _done = false;
  DateTime _created = DateTime.now();
  DateTime? _due;

  String? _nameError;

  @override
  void initState() {
    _tasksRepository = TasksRepositoryImpl();
    _existingTask = widget.task;
    _isUpdating = _existingTask != null;

    initExistingTask();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  initExistingTask() {
    if (_existingTask != null) {
      _name.text = _existingTask!.name;
      _description.text = _existingTask!.description ?? '';
      _done = _existingTask!.done;
      _created = _existingTask!.created;
      _due = _existingTask!.due;
    }
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
              CustomTextInput(
                controller: _name,
                hint: 'Name',
                label: 'Name',
                allowClearButton: false,
                errorText: _nameError,
              ),
              CustomTextInput(
                controller: _description,
                hint: 'Description',
                label: 'Description',
                allowClearButton: false,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
