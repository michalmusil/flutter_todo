import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/domain/models/task/task_model.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/utils/localization_utils.dart';

part 'task_manipulate_state.dart';

class TaskManipulateCubit extends Cubit<TaskManipulateState> {
  late final TasksRepositoryBase _tasksRepository;
  late final AuthServiceBase _authService;

  /// Initializes the cubit for task creation
  TaskManipulateCubit.taskCreate({
    required TasksRepositoryBase tasksRepository,
    required AuthServiceBase authService,
  }) : super(TaskManipulateTaskCreating()) {
    _tasksRepository = tasksRepository;
    _authService = authService;
  }

  /// Initializes the cubit for updating an already existing task
  TaskManipulateCubit.taskUpdate({
    required TasksRepositoryBase tasksRepository,
    required AuthServiceBase authService,
    required TaskModel task,
  }) : super(TaskManipulateTaskUpdating(taskModel: task)) {
    _tasksRepository = tasksRepository;
    _authService = authService;
  }

  /// Gets existing task from the state - only returns the task, if state is TaskUpdating,
  /// otherwise returns null
  TaskModel? _getExistingTask() {
    final existingTask = state is TaskManipulateTaskUpdating
        ? (state as TaskManipulateTaskUpdating).taskModel
        : null;
    return existingTask;
  }

  /// Creates a new task and automatically switches to the appropriate state
  /// This method can only be called when state is TaskCreating
  Future<void> createTask({
    required String name,
    required bool done,
    String? description,
    DateTime? due,
  }) async {
    if (state is! TaskManipulateTaskCreating) {
      emit(TaskManipulateError(
          getMessage: (context) => strings(context).somethingWentWrong));
      return;
    }
    emit(TaskManipulateLoading());
    final userId = _authService.user?.uuid;
    // If user Id can't be retrieved, something went horribly wrong
    if (userId == null) {
      emit(TaskManipulateError(
          getMessage: (context) => strings(context).somethingWentWrong));
      return;
    }

    final newTask = TaskModel(
      id: '',
      userId: userId,
      name: name,
      done: done,
      description: description,
      created: DateTime.now(),
      due: due,
    );

    final created = await _tasksRepository.addTask(
      userId: userId,
      task: newTask,
    );

    if (created) {
      emit(TaskManipulateTaskSaved());
    } else {
      emit(TaskManipulateError(
          getMessage: (context) => strings(context).somethingWentWrong));
    }
  }

  /// Updates already existing task saved in the state and automatically switches to the appropriate state
  /// This function can only be called when state is TaskUpdating!
  Future<void> updateTask(TaskModel task) async {
    // Getting the existing task from the state
    final existingTask = _getExistingTask();
    if (existingTask == null) {
      emit(TaskManipulateError(
          getMessage: (context) => strings(context).somethingWentWrong));
      return;
    }

    emit(TaskManipulateLoading());

    final updated = await _tasksRepository.updateTask(task);

    if (updated) {
      emit(TaskManipulateTaskSaved());
    } else {
      emit(TaskManipulateError(
          getMessage: (context) => strings(context).somethingWentWrong));
    }
  }

  /// Deletes already existing task saved in the state and automatically switches to the appropriate state
  /// This function can only be called when state is TaskUpdating!
  Future<void> deleteTask() async {
    // Getting the existing task from the state
    final existingTask = _getExistingTask();
    if (existingTask == null) {
      emit(TaskManipulateError(
          getMessage: (context) => strings(context).somethingWentWrong));
      return;
    }

    emit(TaskManipulateLoading());

    await _tasksRepository.deleteTask(existingTask);

    emit(TaskManipulateTaskSaved());
  }
}
