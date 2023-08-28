import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/services/auth/auth_service_impl.dart';
import 'package:todo_list/services/auth/iauth_service.dart';

import '../components/forms/custom_text_input.dart';
import '../navigation/nav_router.dart';
import '../services/auth/auth_exception.dart';
import '../utils/images.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late final IAuthService _authService;

  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _errorText;

  @override
  void initState() {
    _authService = AuthServiceImpl();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  _register({required String email, required String password}) async {
    try {
      await _authService.register(email: email, password: password);
      NavRouter.instance.toTasks(context);
    } on InvalidCredentialsException catch (_) {
      setState(() {
        _errorText = "Credentials not valid";
      });
    } on WeakPasswordException catch (_) {
      setState(() {
        _errorText = "Password was too weak";
      });
    } on EmailAlreadyInUseException catch (_) {
      setState(() {
        _errorText = "E-mail is already in use";
      });
    } catch (e) {
      setState(() {
        _errorText = "Registration wasn't successful";
      });
    } finally {
      setState(() {
        _password.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
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
                CustomTextInput(
                  controller: _email,
                  allowClearButton: true,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'E-mail',
                  label: 'E-mail',
                  onTap: () {
                    setState(() {
                      _errorText = null;
                    });
                  },
                ),
                CustomTextInput(
                  controller: _password,
                  obscureText: true,
                  allowClearButton: true,
                  hint: 'Password',
                  label: 'Password',
                  errorText: _errorText,
                  onTap: () {
                    _errorText = null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedPushButton(
                  text: "Register",
                  icon: Icons.person,
                  onClick: () {
                    final email = _email.text;
                    final password = _password.text;
                    if (email.isNotEmpty && password.isNotEmpty) {
                      _register(email: email, password: password);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      NavRouter.instance.toLogin(context);
                    },
                    child: Text(
                      'Go to login',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
