import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';

final registrationErrorProvider = StateProvider<String?>(
  (ref) {
    final exception = ref.watch(authStateProvider)?.exception;
    return exception?.message;
  },
);
