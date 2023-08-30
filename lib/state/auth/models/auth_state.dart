import 'package:todo_list/state/auth/models/auth_exception.dart';
import 'package:todo_list/state/auth/models/auth_user.dart';

class AuthState {
  final AuthUser? user;
  final AuthException? exception;
  final bool isLoading;

  AuthState.fromUser(AuthUser this.user)
      : exception = null,
        isLoading = false;

  AuthState.fromException(AuthException this.exception)
      : user = null,
        isLoading = false;

  AuthState.loading()
      : user = null,
        exception = null,
        isLoading = true;
}
