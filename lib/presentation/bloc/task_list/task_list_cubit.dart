import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/domain/models/task/task_model.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/utils/localization_utils.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  late final AuthServiceBase _authService;
  late final TasksRepositoryBase _tasksRepository;

  TaskListCubit({
    required TasksRepositoryBase tasksRepository,
    required AuthServiceBase authService,
  }) : super(TaskListInitial()) {
    _tasksRepository = tasksRepository;
    _authService = authService;
    fetchTasks();
  }

  // Fetches all the necessary task streams and adds them to state
  Future<void> fetchTasks() async {
    emit(TaskListLoading());

    final userId = _authService.user?.uuid;
    // If user is not authenticated at this point, something went horribly wrong
    if (userId == null) {
      emit(TaskListError(getMessage: (ctx) => strings(ctx).somethingWentWrong));
    }
    try {
      final all = _tasksRepository.tasksStream(userId: userId!, done: null);
      final due = _tasksRepository.tasksStream(userId: userId, done: false);
      final done = _tasksRepository.tasksStream(userId: userId, done: true);

      emit(
        TaskListLoaded(
          allTasks: all,
          dueTasks: due,
          doneTasks: done,
        ),
      );
    } catch (e) {
      emit(
        TaskListError(getMessage: (ctx) => strings(ctx).somethingWentWrong),
      );
    }
  }

  // Task list screen allows the user to log out - after state is logged out, user should be redirected to login screen
  Future<void> logOut() async {
    await _authService.logOut();
    emit(TaskListLoggedOut());
  }
}
