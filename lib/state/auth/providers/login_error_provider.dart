import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_notifier_provider.dart';

final loginErrorProvider = StateProvider<String?>(
  (ref) {
    final exception = ref.watch(authNotifierProvider)?.exception;
    return exception?.message;
  },
);