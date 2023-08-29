import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/models/auth_user.dart';
import 'package:todo_list/state/auth/providers/auth_notifier_provider.dart';

final userProvider = Provider<AuthUser?>(
  (ref) {
    return ref.watch(authNotifierProvider)?.user;
  },
);
