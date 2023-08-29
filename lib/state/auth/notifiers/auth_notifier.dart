import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/bl/auth_service.dart';
import 'package:todo_list/state/auth/bl/auth_service_base.dart';
import 'package:todo_list/state/auth/models/auth_state.dart';

import '../models/auth_exception.dart';

class AuthNotifier extends StateNotifier<AuthState?> {
  final AuthServiceBase authService = const AuthService();

  AuthNotifier() : super(null) {
    _checkLastLoggedInUser();
  }

  // Recovering the user from last session (if not logged out)
  void _checkLastLoggedInUser() async {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (authService.user != null) {
        state = AuthState.fromUser(authService.user!);
      }
    });
  }

  Future<void> logOut() async {
    await authService.logOut();
    state = null;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authService.logIn(email: email, password: password);
      state = AuthState.fromUser(user);
      return;
    } on InvalidCredentialsException catch (e) {
      state = AuthState.fromException(e);
    } on UserNotFoundException catch (e) {
      state = AuthState.fromException(e);
    } catch (_) {
      state = AuthState.fromException(AuthException());
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await authService.register(email: email, password: password);
      final loggedInUser =
          await authService.logIn(email: email, password: password);
      state = AuthState.fromUser(loggedInUser);
      return;
    } on EmailAlreadyInUseException catch (e) {
      state = AuthState.fromException(e);
    } on InvalidCredentialsException catch (e) {
      state = AuthState.fromException(e);
    } on WeakPasswordException catch (e) {
      state = AuthState.fromException(e);
    } catch (_) {
      state = AuthState.fromException(AuthException());
    }
  }
}
