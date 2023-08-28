import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
import 'package:todo_list/components/misc/rounded_push_button.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/services/auth/auth_exception.dart';
import 'package:todo_list/services/auth/auth_service_impl.dart';
import 'package:todo_list/services/auth/iauth_service.dart';
import 'package:todo_list/utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  late final IAuthService _authService;

  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _errorText;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _authService = AuthServiceImpl();
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

  _logIn({required String email, required String password}) async {
    try {
      await _authService.logIn(email: email, password: password);
      NavRouter.instance.toTasks(context);
    } on UserNotFoundException catch (_) {
      setState(() {
        _errorText = "E-mail not recognized";
      });
    } on InvalidCredentialsException catch (_) {
      setState(() {
        _errorText = "Invalid credentials";
      });
    } catch (e) {
      setState(() {
        _errorText = "Logging in wasn't successful";
      });
    } finally {
      setState(() {
        _password.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

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
                //const Spacer(),
                SvgPicture.asset(
                  Images.appIcon.url,
                  width: 130,
                  height: 130,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Log in",
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
                  text: "Log in",
                  icon: Icons.login_rounded,
                  onClick: () {
                    final email = _email.text;
                    final password = _password.text;
                    if (email.isNotEmpty && password.isNotEmpty) {
                      _logIn(email: email, password: password);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      NavRouter.instance.toRegistration(context);
                    },
                    child: Text(
                      'Go to registration',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                //const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
