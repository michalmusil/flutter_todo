import 'package:flutter/material.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/navigation/routes.dart';

class NavRouter {
  static final instance = NavRouter();

  void returnBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> toLogin(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login.route,
      (route) => false,
    );
  }

  Future<void> toRegistration(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.registration.route,
      (route) => false,
    );
  }

  Future<void> toTasks(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.tasks.route,
      (route) => false,
    );
  }

  Future<void> toTaskDetail(BuildContext context, {required TaskModel task}) {
    return Navigator.of(context).pushNamed(
      Routes.taskDetail.route,
      arguments: task
    );
  }

  Future<void> toTaskCreateOrUpdate(BuildContext context, {TaskModel? task}) {
    return Navigator.of(context).pushNamed(
      Routes.taskCreateOrUpdate.route,
      arguments: task
    );
  }
}
