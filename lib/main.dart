import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/presentation/screens/splash.dart';
import 'package:todo_list/config/themes.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();

  runApp(
    const TodoApplication(),
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
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: darkColorScheme.background,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
      ),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateRoute: NavRouter.onGenerateRoute,
      home: Splash(),
      builder: (builderContext, child) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(builderContext).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          statusBarBrightness:
              Theme.of(builderContext).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
        ));

        // Need to return an overlay widget to be able to globally display the loading overlay
        // Child is returned in the overlay entry builder
        // return Overlay(
        //   initialEntries: [
        //     OverlayEntry(
        //       builder: (context) {
        //         return Consumer(
        //           builder: (ctx, ref, _) {
        //             ref.listen(
        //               appLoadingProvider,
        //               (previous, next) {
        //                 if (next) {
        //                   LoadingOverlay.instance().show(context);
        //                 } else {
        //                   LoadingOverlay.instance().hide();
        //                 }
        //               },
        //             );

        //             return child ?? Container();
        //           },
        //         );
        //       },
        //     ),
        //   ],
        // );

        return child ?? Container();
      },
    );
  }
}
