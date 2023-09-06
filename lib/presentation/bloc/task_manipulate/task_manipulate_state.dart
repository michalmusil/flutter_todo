part of 'task_manipulate_cubit.dart';

@immutable
sealed class TaskManipulateState {}

final class TaskManipulateTaskCreating extends TaskManipulateState {}

final class TaskManipulateTaskUpdating extends TaskManipulateState {
  // ignore: unused_field
  final TaskModel taskModel;

  TaskManipulateTaskUpdating({required this.taskModel});
}

final class TaskManipulateLoading extends TaskManipulateState {}

final class TaskManipulateError extends TaskManipulateState {
  final String Function(BuildContext context) getMessage;
  final Exception? exception;

  TaskManipulateError({
    required this.getMessage,
    this.exception,
  });
}

final class TaskManipulateTaskSaved extends TaskManipulateState {}
