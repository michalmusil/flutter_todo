import 'package:flutter/material.dart';
import 'package:todo_list/components/forms/custom_text_input.dart';
import 'package:todo_list/navigation/nav_router.dart';
import 'package:todo_list/services/auth/auth_exception.dart';
import 'package:todo_list/services/auth/auth_service_impl.dart';
import 'package:todo_list/services/auth/iauth_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextInput(
              controller: _email,
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
              hint: 'Password',
              label: 'Password',
              errorText: _errorText,
              onTap: () {
                _errorText = null;
              },
            ),
            OutlinedButton(
              onPressed: () {
                final email = _email.text;
                final password = _password.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  _logIn(email: email, password: password);
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.secondary),
                  foregroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.onSecondary)),
              child: const Text('Log in'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: TextButton(
                onPressed: () {
                  NavRouter.instance.toRegistration(context);
                },
                child: const Text('Go to registration'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
