import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_notifier_provider.dart';
import 'package:todo_list/state/auth/providers/registration_error_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/utils/images.dart';

import '../state/auth/providers/login_error_provider.dart';

class Registration extends ConsumerWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Registration({super.key});

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
                SvgPicture.asset(
                  Images.appIcon.url,
                  width: 130,
                  height: 130,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Register",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily:
                        Theme.of(context).textTheme.titleLarge!.fontFamily,
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return CustomTextInput(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'E-mail',
                      label: 'E-mail',
                      onTap: () {
                        ref.read(registrationErrorProvider.notifier).state =
                            null;
                      },
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final errorMessage = ref.watch(registrationErrorProvider);
                    ref.listen(
                      registrationErrorProvider,
                      (previous, errorText) {
                        if (errorText != null) {
                          _password.text = "";
                        }
                      },
                    );
                    return CustomTextInput(
                      controller: _password,
                      obscureText: true,
                      hint: 'Password',
                      label: 'Password',
                      errorText: errorMessage,
                      onTap: () {
                        ref.read(registrationErrorProvider.notifier).state =
                            null;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final authNotifier =
                        ref.watch(authNotifierProvider.notifier);

                    return RoundedPushButton(
                      text: "Register",
                      icon: Icons.person,
                      onClick: () {
                        final email = _email.text;
                        final password = _password.text;
                        if (email.isNotEmpty && password.isNotEmpty) {
                          authNotifier.register(
                              email: email, password: password);
                        }
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      ref.read(loginErrorProvider.notifier).state = null;
                      ref.read(registrationErrorProvider.notifier).state = null;
                      NavRouter.instance().toLogin(context);
                    },
                    child: Text(
                      'Go to login',
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
