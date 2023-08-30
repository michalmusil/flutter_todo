import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_state_provider.dart';

final loginErrorProvider = StateProvider<String Function(BuildContext)?>(
  (ref) {
    final exception = ref.watch(authStateProvider)?.exception;
    return exception?.getLocalizedMessage;
  },
);