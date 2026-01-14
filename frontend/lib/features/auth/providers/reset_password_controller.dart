import 'dart:async';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_controller.g.dart';

@riverpod
class ResetPasswordController extends _$ResetPasswordController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(
    String email, {
    String? redirectTo,
  }) async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      await ref
          .read(authProvider.notifier)
          .resetPassword(email, redirectTo: redirectTo);
    });
    state = next;
  }
}
