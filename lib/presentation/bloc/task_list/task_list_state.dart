part of 'task_list_cubit.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

final class TaskListLoading extends TaskListState {}

final class TaskListError extends TaskListState {
  final String Function(BuildContext) getMessage;
  final Exception? exception;

  TaskListError({
    required this.getMessage,
    this.exception,
  });
}

// Task list screen allows the user to log out
final class TaskListLoggedOut extends TaskListState {}

final class TaskListLoaded extends TaskListState {
  final Stream<Iterable<TaskModel>> allTasks;
  final Stream<Iterable<TaskModel>> dueTasks;
  final Stream<Iterable<TaskModel>> doneTasks;

  TaskListLoaded({
    required this.allTasks,
    required this.dueTasks,
    required this.doneTasks,
  });
}
