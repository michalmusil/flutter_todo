import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
}
