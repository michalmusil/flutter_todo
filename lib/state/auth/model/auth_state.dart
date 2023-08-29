import 'package:todo_list/state/auth/model/auth_exception.dart';
import 'package:todo_list/state/auth/model/auth_user.dart';

class AuthState {
  final AuthUser? user;
  final AuthException? exception;

  AuthState.fromUser(AuthUser this.user) : exception = null;

  AuthState.fromException(AuthException this.exception) : user = null;
}
