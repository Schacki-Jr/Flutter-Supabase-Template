import 'dart:async';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> submit(
    String email,
    String password, {
    String? redirectTo,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authProvider.notifier)
          .signUp(email, password, redirectTo: redirectTo);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
