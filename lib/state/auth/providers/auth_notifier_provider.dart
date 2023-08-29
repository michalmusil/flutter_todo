import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/models/auth_state.dart';
import 'package:todo_list/state/auth/notifiers/auth_notifier.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState?>(
  (_) {
    return AuthNotifier();
  },
);
