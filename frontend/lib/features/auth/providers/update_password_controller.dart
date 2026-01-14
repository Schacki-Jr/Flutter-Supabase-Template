import 'dart:async';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_password_controller.g.dart';

@riverpod
class UpdatePasswordController extends _$UpdatePasswordController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(String newPassword) async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      await ref.read(authProvider.notifier).updatePassword(newPassword);
    });
    state = next;
  }
}
