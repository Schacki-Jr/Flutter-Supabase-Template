import 'dart:async';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_otp_controller.g.dart';

@riverpod
class ResetOtpController extends _$ResetOtpController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> submit(String email, String otp) async {
    state = const AsyncLoading();
    final supabase = ref.read(supabaseServiceProvider);
    try {
      await supabase.verifyRecoveryOtp(email: email, token: otp);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
