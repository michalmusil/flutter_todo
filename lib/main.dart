import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/navigation/routes.dart';
import 'package:todo_list/screens/login.dart';
import 'package:todo_list/screens/registration.dart';
import 'package:todo_list/screens/task_create_update.dart';
import 'package:todo_list/screens/task_detail.dart';
import 'package:todo_list/screens/tasks.dart';
import 'package:todo_list/themes.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TodoApplication());
}

class TodoApplication extends StatelessWidget {
  const TodoApplication({super.key});

  void initializeFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future(() {
      initializeFirebase();
    }), builder: (context, snapshot) {
      return MaterialApp(
        title: 'Todo app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: lightColorScheme.background,
          brightness: Brightness.light,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: darkColorScheme.background,
          brightness: Brightness.dark,
          colorScheme: darkColorScheme,
        ),
        home: const LoginScreen(),
        onGenerateRoute: (settings) {
          final arguments = settings.arguments;
          final routes = <String, WidgetBuilder>{
            Routes.login.route: (context) => const LoginScreen(),
            Routes.registration.route: (context) => const Registration(),
            Routes.tasks.route: (context) => const TasksScreen(),
            Routes.taskDetail.route: (context) =>
                TaskDetail(task: arguments as TaskModel),
            Routes.taskCreateOrUpdate.route: (context) =>
                TaskCreateUpdate(task: arguments as TaskModel?),
          };
          final currentBuilder = routes[settings.name]!;
          return MaterialPageRoute(builder: (ctx) => currentBuilder(ctx));
        },
      );
    });
  }
}
