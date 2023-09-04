import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/domain/models/auth/auth_state.dart';
import 'package:todo_list/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState?>(
  (_) {
    return AuthStateNotifier();
  },
);
