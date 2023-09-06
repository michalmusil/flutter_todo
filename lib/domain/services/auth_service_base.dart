import 'package:todo_list/domain/models/auth/auth_user.dart';

abstract class AuthServiceBase{
  AuthUser? get user;

  Future<AuthUser> logIn({required String email, required String password});

  Future<AuthUser> register({required String email, required String password});

  Future<bool> logOut();
}