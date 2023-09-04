import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/domain/models/auth/auth_user.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';

final userProvider = Provider<AuthUser?>(
  (ref) {
    return ref.watch(authStateProvider)?.user;
  },
);
