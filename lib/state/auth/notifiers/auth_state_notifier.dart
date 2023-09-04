import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/data/services/auth_service.dart';
import 'package:todo_list/domain/models/auth/auth_exception.dart';
import 'package:todo_list/domain/models/auth/auth_state.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';

class AuthStateNotifier extends StateNotifier<AuthState?> {
  final AuthServiceBase authService = const AuthService();

  AuthStateNotifier() : super(null) {
    _checkLastLoggedInUser();
  }

  // Recovering the user from last session (if not logged out)
  void _checkLastLoggedInUser() {
    if (authService.user != null) {
      state = AuthState.fromUser(authService.user!);
    }
  }

  Future<void> logOut() async {
    state = AuthState.loading();
    await authService.logOut();
    state = null;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();
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
    state = AuthState.loading();
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
