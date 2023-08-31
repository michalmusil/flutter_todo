import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/forms/custom_date_time_picker.dart';
import 'package:todo_list/components/forms/custom_switch.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/state/tasks/notifiers/task_repo_notifier.dart';
import 'package:todo_list/state/tasks/providers/task_repo_state_provider.dart';
import 'package:todo_list/utils/localization_utils.dart';

import '../components/popups/confirmation_popup.dart';
import '../state/tasks/models/task_model.dart';
import '../navigation/nav_router.dart';

class TaskCreateUpdate extends StatefulWidget {
  const TaskCreateUpdate({super.key, this.task});

  final TaskModel? task;

  @override
  State<TaskCreateUpdate> createState() => _TaskCreateUpdateState();
}

class _TaskCreateUpdateState extends State<TaskCreateUpdate> {
  late final TaskModel? _existingTask;
  late final bool _isUpdating;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool _done = false;
  DateTime? _due;

  String? _nameError;

  @override
  void initState() {
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

  _handleSave({
    required BuildContext context,
    required String userId,
    required TaskRepoNotifier repositoryNotifier,
  }) async {
    if (_name.text.isEmpty) {
      setState(() {
        _nameError = strings(context).nameCantBeEmpty;
      });
      return;
    }
    if (_isUpdating && _existingTask != null) {
      _existingTask!.name = _name.text;
      _existingTask!.description = _description.text;
      _existingTask!.done = _done;
      _existingTask!.due = _due;

      final newValues = _existingTask!.copyWith(
        name: _name.text,
        description: _description.text,
        done: _done,
        due: _due,
      );

      await repositoryNotifier.updateTask(task: newValues).then(
        (_) {
          NavRouter.instance().toTasks(context);
        },
      );
    } else {
      var newTask = TaskModel(
        id: '',
        userId: '',
        name: _name.text,
        description: _description.text,
        done: _done,
        created: DateTime.now(),
        due: _due,
      );
      await repositoryNotifier.addTask(userId: userId, task: newTask).then((_) {
        NavRouter.instance().toTasks(context);
      });
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
          (_isUpdating == true
              ? strings(context).updateTask
              : strings(context).newTask),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            NavRouter.instance().returnBack(context);
          },
        ),
        actions: [
          Visibility(
            visible: _isUpdating,
            child: Consumer(
              builder: (context, ref, child) {
                final taskRepoNotifier =
                    ref.watch(taskRepoStateProvider.notifier);

                return IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ConfirmationPopup(
                        title: strings(context).deleteTask,
                        message:
                            strings(context).sureToDeleteTask,
                        onConfirm: () async {
                          await taskRepoNotifier
                              .deleteTask(task: _existingTask!)
                              .then((_) {
                            NavRouter.instance().toTasks(context);
                          });
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                );
              },
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
                hint: strings(context).name,
                label: strings(context).name,
                allowClearButton: false,
                errorText: _nameError,
              ),
              CustomTextInput(
                controller: _description,
                hint: strings(context).description,
                label: strings(context).description,
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
                label: strings(context).done,
              ),
              CustomDateTimePicker(
                label: strings(context).due,
                initialDate: _due,
                onDateTimePicked: (newDate, _) {
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
                  Consumer(
                    builder: (context, ref, child) {
                      final loggedInUser = ref.watch(userProvider);

                      return RoundedPushButton(
                        text: strings(context).save,
                        icon: Icons.save_alt_rounded,
                        onClick: () {
                          if (loggedInUser != null) {
                            _handleSave(
                              context: context,
                              userId: loggedInUser.uuid,
                              repositoryNotifier:
                                  ref.read(taskRepoStateProvider.notifier),
                            );
                          }
                        },
                      );
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
