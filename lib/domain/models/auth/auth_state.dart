import 'auth_exception.dart';
import 'auth_user.dart';

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
