import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/services/auth/auth_service_impl.dart';
import 'package:todo_list/services/auth/iauth_service.dart';

import '../navigation/nav_router.dart';
import '../services/auth/auth_exception.dart';

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

  void register({required String email, required String password}) async {
    try {
      await _authService.register(email: email, password: password);
      NavRouter.instance.toTasks(context);
    } on InvalidCredentialsException catch(_) {
      setState(() {
        _errorText = "Credentials not valid";
      });
    } on WeakPasswordException catch(_) {
      setState(() {
        _errorText = "Password was too weak";
      });
    } on EmailAlreadyInUseException catch(_) {
      setState(() {
        _errorText = "E-mail is already in use";
      });
    }
    catch (e) {
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
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: 'E-mail'),
              onTap: () {
                setState(() {
                  _errorText = null;
                });
              },
            ),
            TextField(
              controller: _password,
              keyboardType: TextInputType.text,
              autocorrect: false,
              obscureText: true,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.none,
              decoration:
                  InputDecoration(hintText: 'Password', errorText: _errorText),
              onTap: () {
                setState(() {
                  _errorText = null;
                });
              },
            ),
            TextButton(
              onPressed: () {
                final email = _email.text;
                final password = _email.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  register(email: email, password: password);
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.secondary),
                  foregroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.onSecondary)),
              child: const Text('Register'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: TextButton(
                onPressed: () {
                  NavRouter.instance.toLogin(context);
                },
                child: const Text('Go to login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}