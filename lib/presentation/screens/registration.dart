import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/locator.dart';
import 'package:todo_list/presentation/bloc/authentication/authentication_cubit.dart';
import 'package:todo_list/presentation/components/decorative/registration_banner.dart';
import 'package:todo_list/presentation/components/forms/custom_text_input.dart';
import 'package:todo_list/presentation/components/misc/rounded_push_button.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/presentation/components/overlay/loading_overlay.dart';
import 'package:todo_list/utils/localization_utils.dart';

class Registration extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(
        authService: locator<AuthServiceBase>(),
      ),
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          switch (state) {
            case AuthenticationLoading():
              {
                LoadingOverlay.instance().show(context);
                break;
              }
            case AuthenticationFailure(getMessage: _):
              {
                _password.text = "";
                LoadingOverlay.instance().hide();
                break;
              }
            case AuthenticationSuccess(user: _):
              {
                LoadingOverlay.instance().hide();
                NavRouter.instance().toTasks(context);
                break;
              }
            default:
              {
                LoadingOverlay.instance().hide();
                break;
              }
          }
        },
        child: Scaffold(
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
                    BlocBuilder<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        final cubit =
                            BlocProvider.of<AuthenticationCubit>(context);

                        return CustomTextInput(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          hint: strings(context).email,
                          label: strings(context).email,
                          onTap: () {
                            cubit.eraseError();
                          },
                        );
                      },
                    ),
                    BlocBuilder<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        final cubit =
                            BlocProvider.of<AuthenticationCubit>(context);

                        return CustomTextInput(
                          controller: _password,
                          obscureText: true,
                          hint: strings(context).password,
                          label: strings(context).password,
                          errorText: state is AuthenticationFailure
                              ? state.getMessage(context)
                              : null,
                          onTap: () {
                            cubit.eraseError();
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        final cubit =
                            BlocProvider.of<AuthenticationCubit>(context);

                        return RoundedPushButton(
                          text: strings(context).register,
                          icon: Icons.person,
                          onClick: () {
                            final email = _email.text;
                            final password = _password.text;
                            if (email.isNotEmpty && password.isNotEmpty) {
                              cubit.register(email: email, password: password);
                            }
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                      child: TextButton(
                        onPressed: () {
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
        ),
      ),
    );
  }
}
