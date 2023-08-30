import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/overlay/loading_overlay.dart';
import 'package:todo_list/state/global/providers/app_loading_provider.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';
import 'package:todo_list/navigation/routes.dart';
import 'package:todo_list/screens/login.dart';
import 'package:todo_list/screens/registration.dart';
import 'package:todo_list/screens/task_create_update.dart';
import 'package:todo_list/screens/task_detail.dart';
import 'package:todo_list/screens/tasks.dart';
import 'package:todo_list/themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: TodoApplication(),
    ),
  );
}

class TodoApplication extends StatelessWidget {
  const TodoApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
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
      onGenerateRoute: (settings) {
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
      },
      builder: (_, child) {
        // Need to return an overlay widget to be able to globally display the loading overlay
        // Child is returned in the overlay entry builder
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return Consumer(
                  builder: (ctx, ref, _) {
                    ref.listen(
                      appLoadingProvider,
                      (previous, next) {
                        if (next) {
                          LoadingOverlay.instance().show(context);
                        } else {
                          LoadingOverlay.instance().hide();
                        }
                      },
                    );

                    return child ?? Container();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
