import 'dart:async';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

// Use a Notifier whose state is an AsyncValue<void> to avoid
// AsyncNotifier's internal completer double-completion on web.
@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<void> build() {
    // Idle state
    return const AsyncData(null);
  }

  Future<void> submit(String email, String password) async {
    // mark as loading
    state = const AsyncLoading();
    try {
      await ref.read(authProvider.notifier).signIn(email, password);
      // success
      state = const AsyncData(null);
    } catch (e, st) {
      // error
      state = AsyncError(e, st);
    }
  }
}
