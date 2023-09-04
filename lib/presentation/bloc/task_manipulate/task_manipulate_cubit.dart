import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'task_manipulate_state.dart';

class TaskManipulateCubit extends Cubit<TaskManipulateState> {
  TaskManipulateCubit() : super(TaskManipulateInitial());
}
