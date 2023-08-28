import 'package:flutter/material.dart';
import 'package:todo_list/components/forms/custom_date_picker.dart';
import 'package:todo_list/components/forms/custom_switch.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/repositories/tasks_repository_impl.dart';

import '../components/popups/confirmation_popup.dart';
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
  DateTime? _due;

  String? _nameError;

  @override
  void initState() {
    _tasksRepository = TasksRepositoryImpl();
    _existingTask = widget.task;
    _isUpdating = _existingTask != null;

    _initExistingTask();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  _initExistingTask() {
    if (_existingTask != null) {
      _name.text = _existingTask!.name;
      _description.text = _existingTask!.description ?? '';
      _done = _existingTask!.done;
      _due = _existingTask!.due;
    }
  }

  _handleSave(BuildContext context) async {
    if (_name.text.isEmpty) {
      setState(() {
        _nameError = "Name can't be left empty";
      });
      return;
    }
    if (_isUpdating && _existingTask != null) {
      _existingTask!.name = _name.text;
      _existingTask!.description = _description.text;
      _existingTask!.done = _done;
      _existingTask!.due = _due;

      var updated = await _tasksRepository.updateTask(_existingTask!);
      if (updated) {
        NavRouter.instance.toTasks(context);
      }
    } else {
      var newTask = TaskModel(
        uuid: 'undefined',
        name: _name.text,
        description: _description.text,
        done: _done,
        created: DateTime.now(),
        due: _due,
      );
      var created = await _tasksRepository.addTask(newTask);
      if (created) {
        NavRouter.instance.toTasks(context);
      }
    }
  }

  _deleteTask(BuildContext context) async {
    if (_isUpdating) {
      var deleted = await _tasksRepository.deleteTask(_existingTask!);
      if (deleted) {
        NavRouter.instance.toTasks(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        title: Text(
          (_isUpdating == true ? "Update task" : "Add task"),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            NavRouter.instance.returnBack(context);
          },
        ),
        actions: [
          Visibility(
            visible: _isUpdating,
            child: IconButton(
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
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
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
              CustomSwitch(
                value: _done,
                onCheckChanged: (value) {
                  setState(() {
                    _done = value;
                  });
                },
                label: "Done",
              ),
              CustomDatePicker(
                label: "Due",
                initialDate: _due,
                onDatePicked: (newDate) {
                  setState(() {
                    _due = newDate;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundedPushButton(
                    text: "Save",
                    icon: Icons.save_alt_rounded,
                    onClick: () {
                      _handleSave(context);
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
}
