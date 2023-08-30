import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_state_provider.dart';

final loginErrorProvider = StateProvider<String?>(
  (ref) {
    final exception = ref.watch(authStateProvider)?.exception;
    return exception?.message;
  },
);