import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/domain/models/auth/auth_exception.dart';
import 'package:todo_list/domain/models/auth/auth_user.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/utils/localization_utils.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late final AuthServiceBase _authService;

  AuthenticationCubit({
    required AuthServiceBase authService,
  }) : super(AuthenticationInitial()) {
    _authService = authService;
    _checkLastLoggedInUser();
  }

  // Recovering the user from last session (if not logged out)
  void _checkLastLoggedInUser() {
    if (_authService.user != null) {
      emit(
        AuthenticationSuccess(user: _authService.user!),
      );
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    emit(AuthenticationLoading());

    try {
      final user = await _authService.logIn(
        email: email,
        password: password,
      );
      emit(AuthenticationSuccess(user: user));
    } on InvalidCredentialsException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } on UserNotFoundException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } on AuthException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } catch (e) {
      emit(AuthenticationFailure(getMessage: (ctx) {
        return strings(ctx).somethingWentWrong;
      }));
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(AuthenticationLoading());

    try {
      final user = await _authService.register(
        email: email,
        password: password,
      );
      emit(AuthenticationSuccess(user: user));
    } on InvalidCredentialsException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } on EmailAlreadyInUseException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } on WeakPasswordException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } on AuthException catch (e) {
      emit(AuthenticationFailure(
        getMessage: e.getLocalizedMessage,
        exception: e,
      ));
    } catch (e) {
      emit(AuthenticationFailure(getMessage: (ctx) {
        return strings(ctx).somethingWentWrong;
      }));
    }
  }

  // If state is failure, this changes the state to initial (so that error messages can be removed even without successfull login or registration)
  void eraseError() {
    if (state is AuthenticationFailure) {
      emit(AuthenticationInitial());
    }
  }
}
