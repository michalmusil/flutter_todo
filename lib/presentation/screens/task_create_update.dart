import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/locator.dart';
import 'package:todo_list/presentation/bloc/task_manipulate/task_manipulate_cubit.dart';
import 'package:todo_list/presentation/components/forms/custom_date_time_picker.dart';
import 'package:todo_list/presentation/components/forms/custom_switch.dart';
import 'package:todo_list/presentation/components/forms/custom_text_input.dart';
import 'package:todo_list/presentation/components/misc/rounded_push_button.dart';
import 'package:todo_list/presentation/components/overlay/loading_overlay.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/state/tasks/notifiers/task_repo_notifier.dart';
import 'package:todo_list/state/tasks/providers/task_repo_state_provider.dart';
import 'package:todo_list/utils/localization_utils.dart';

import '../components/popups/confirmation_popup.dart';
import '../../domain/models/task/task_model.dart';
import '../../config/navigation/nav_router.dart';

class TaskCreateUpdate extends StatefulWidget {
  late final TaskModel? _existingTask;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool _done = false;
  DateTime? _due;

  String? _nameError;

  TaskCreateUpdate({super.key, TaskModel? existingTask}) {
    _existingTask = existingTask;
    if (existingTask != null) {
      _name.text = existingTask.name;
      _description.text = existingTask.description ?? '';
      _done = existingTask.done;
      _due = existingTask.due;
    }
  }

  @override
  State<StatefulWidget> createState() => _TaskCreateUpdateState();
}

class _TaskCreateUpdateState extends State<TaskCreateUpdate> {
  late final bool _isUpdating;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool _done = false;
  DateTime? _due;

  String? _nameError;

  @override
  void initState() {
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
    if (widget._existingTask != null) {
      _name.text = widget._existingTask!.name;
      _description.text = widget._existingTask!.description ?? '';
      _done = widget._existingTask!.done;
      _due = widget._existingTask!.due;
    }
  }

  _handleSave({
    required BuildContext context,
    required TaskManipulateState state,
    required TaskManipulateCubit cubit,
  }) async {
    if (_name.text.isEmpty) {
      setState(() {
        _nameError = strings(context).nameCantBeEmpty;
      });
      return;
    }
    switch (state) {
      case TaskManipulateTaskCreating():
        {
          cubit.createTask(
            name: _name.text,
            done: _done,
            description: _description.text,
            due: _due,
          );
        }
      case TaskManipulateTaskUpdating(taskModel: final oldTask):
        {
          final newTask = oldTask.copyWith(
            name: _name.text,
            done: _done,
          );
          newTask.description = _description.text;
          newTask.due = _due;
          cubit.updateTask(newTask);
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget._existingTask == null) {
          return TaskManipulateCubit.taskCreate(
            tasksRepository: locator<TasksRepositoryBase>(),
            authService: locator<AuthServiceBase>(),
          );
        } else {
          return TaskManipulateCubit.taskUpdate(
            tasksRepository: locator<TasksRepositoryBase>(),
            authService: locator<AuthServiceBase>(),
            task: widget._existingTask!,
          );
        }
      },
      child: BlocListener<TaskManipulateCubit, TaskManipulateState>(
        listener: (context, state) {
          switch (state) {
            case TaskManipulateTaskSaved():
              {
                LoadingOverlay.instance().hide();
                NavRouter.instance().toTasks(context);
              }
            case TaskManipulateLoading():
              LoadingOverlay.instance().show(context);
            default:
              LoadingOverlay.instance().hide();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.onBackground,
            elevation: 0,
            title: BlocBuilder<TaskManipulateCubit, TaskManipulateState>(
              buildWhen: (previous, current) =>
                  current is TaskManipulateTaskCreating ||
                  current is TaskManipulateTaskUpdating,
              builder: (context, state) {
                var text = "";
                switch (state) {
                  case TaskManipulateTaskCreating():
                    text = strings(context).newTask;
                  case TaskManipulateTaskUpdating():
                    text = strings(context).updateTask;
                  default:
                    text = "";
                }
                return Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                NavRouter.instance().returnBack(context);
              },
            ),
            actions: [
              BlocBuilder<TaskManipulateCubit, TaskManipulateState>(
                buildWhen: (previous, current) =>
                    current is TaskManipulateTaskCreating ||
                    current is TaskManipulateTaskUpdating,
                builder: (context, state) {
                  final cubit = BlocProvider.of<TaskManipulateCubit>(context);
                  return Visibility(
                    visible: state is TaskManipulateTaskUpdating,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ConfirmationPopup(
                            title: strings(context).deleteTask,
                            message: strings(context).sureToDeleteTask,
                            onConfirm: () async {
                              await cubit.deleteTask().then((_) {
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
                    ),
                  );
                },
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
                      BlocBuilder<TaskManipulateCubit, TaskManipulateState>(
                        builder: (context, state) {
                          final cubit =
                              BlocProvider.of<TaskManipulateCubit>(context);

                          return RoundedPushButton(
                            text: strings(context).save,
                            icon: Icons.save_alt_rounded,
                            onClick: () {
                              _handleSave(
                                context: context,
                                state: state,
                                cubit: cubit,
                              );
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
        ),
      ),
    );
  }
}
