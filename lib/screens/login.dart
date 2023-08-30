import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/decorative/login_banner.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';
import 'package:todo_list/state/auth/providers/login_error_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/utils/images.dart';
import 'package:todo_list/utils/localization_utils.dart';

import '../state/auth/providers/registration_error_provider.dart';

class Login extends ConsumerWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

    ref.listen(
      userProvider,
      (previous, currentUser) {
        if (currentUser != null) {
          NavRouter.instance().toTasks(context);
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 80,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginBanner(),
                const SizedBox(
                  height: 30,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return CustomTextInput(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      hint: strings(context).email,
                      label: strings(context).email,
                      onTap: () {
                        ref.read(loginErrorProvider.notifier).state = null;
                      },
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final errorGetter = ref.watch(loginErrorProvider);
                    ref.listen(
                      loginErrorProvider,
                      (previous, err) {
                        if (err != null) {
                          _password.text = "";
                        }
                      },
                    );

                    return CustomTextInput(
                      controller: _password,
                      obscureText: true,
                      hint: strings(context).password,
                      label: strings(context).email,
                      errorText:
                          errorGetter != null ? errorGetter(context) : null,
                      onTap: () {
                        ref.read(loginErrorProvider.notifier).state = null;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final authNotifier = ref.watch(authStateProvider.notifier);

                    return RoundedPushButton(
                      text: strings(context).login,
                      icon: Icons.login_rounded,
                      onClick: () {
                        final email = _email.text;
                        final password = _password.text;
                        if (email.isNotEmpty && password.isNotEmpty) {
                          authNotifier.logIn(email: email, password: password);
                        }
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      ref.read(registrationErrorProvider.notifier).state = null;
                      ref.read(loginErrorProvider.notifier).state = null;
                      NavRouter.instance().toRegistration(context);
                    },
                    child: Text(
                      strings(context).goToRegistration,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
