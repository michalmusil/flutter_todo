import 'package:flutter/material.dart';
import 'package:todo_list/presentation/screens/login.dart';
import 'package:todo_list/presentation/screens/registration.dart';
import 'package:todo_list/presentation/screens/task_create_update.dart';
import 'package:todo_list/presentation/screens/task_detail.dart';
import 'package:todo_list/presentation/screens/tasks.dart';
import 'package:todo_list/domain/models/task/task_model.dart';
import 'package:todo_list/config/navigation/routes.dart';

class NavRouter {
  NavRouter._();

  static final _instance = NavRouter._();
  factory NavRouter.instance() => _instance;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    final routes = <String, WidgetBuilder>{
      Routes.login.route: (context) => Login(),
      Routes.registration.route: (context) => Registration(),
      Routes.tasks.route: (context) => const Tasks(),
      Routes.taskDetail.route: (context) =>
          TaskDetail(task: arguments as TaskModel),
      Routes.taskCreateOrUpdate.route: (context) =>
          TaskCreateUpdate(task: arguments as TaskModel?),
    };
    final currentBuilder = routes[settings.name]!;
    return MaterialPageRoute(builder: (ctx) => currentBuilder(ctx));
  }

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
    return Navigator.of(context)
        .pushNamed(Routes.taskDetail.route, arguments: task);
  }

  Future<void> toTaskCreateOrUpdate(BuildContext context, {TaskModel? task}) {
    return Navigator.of(context)
        .pushNamed(Routes.taskCreateOrUpdate.route, arguments: task);
  }
}
