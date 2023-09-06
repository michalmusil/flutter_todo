part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationSuccess extends AuthenticationState {
  final AuthUser user;

  AuthenticationSuccess({
    required this.user,
  });
}

final class AuthenticationFailure extends AuthenticationState {
  final AuthException? exception;
  final String Function(BuildContext context) getMessage;

  AuthenticationFailure({
    required this.getMessage,
    this.exception,
  });
}
