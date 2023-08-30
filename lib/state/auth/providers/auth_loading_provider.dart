import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/state/auth/providers/auth_state_provider.dart';

final authLoadingProvider = Provider<bool>(
  (ref) {
    final isLoading = ref.watch(authStateProvider)?.isLoading ?? false;
    return isLoading;
  },
);
