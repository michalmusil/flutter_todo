import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/presentation/components/decorative/registration_banner.dart';
import 'package:todo_list/presentation/components/forms/custom_text_input.dart';
import 'package:todo_list/presentation/components/misc/rounded_push_button.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';
import 'package:todo_list/state/auth/providers/registration_error_provider.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/utils/localization_utils.dart';

import '../../state/auth/providers/login_error_provider.dart';

class Registration extends ConsumerWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Registration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                const RegistrationBanner(),
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
                        ref.read(registrationErrorProvider.notifier).state =
                            null;
                      },
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final errorGetter = ref.watch(registrationErrorProvider);
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
                      hint: strings(context).password,
                      label: strings(context).password,
                      errorText:
                          errorGetter != null ? errorGetter(context) : null,
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
                    final authNotifier = ref.watch(authStateProvider.notifier);

                    return RoundedPushButton(
                      text: strings(context).register,
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
                      strings(context).goToLogin,
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
