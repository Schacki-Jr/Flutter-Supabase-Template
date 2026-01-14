import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/features/auth/models/auth_state.dart';
import 'package:flutter_supabase_template/features/auth/models/user_profile.dart';
import 'package:flutter_supabase_template/shared/services/supabase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
SupabaseService supabaseService(Ref ref) {
  return SupabaseService();
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final SupabaseService _supabase;
  StreamSubscription<AuthState>? _sub;

  @override
  L2aAuthState build() {
    _supabase = ref.watch(supabaseServiceProvider);
    _init();
    ref.onDispose(() {
      _sub?.cancel();
    });
    return const L2aAuthState.loading();
  }

  void _init() {
    final session = _supabase.currentSession;
    if (session?.user != null) {
      state = L2aAuthState.authenticated(
        UserProfile(email: session!.user.email ?? ''),
      );
    } else {
      state = const L2aAuthState.unauthenticated();
    }

    _sub = _supabase.onAuthStateChange.listen((event) {
      final session = event.session;
      final e = event.event;

      if (e == AuthChangeEvent.passwordRecovery) {
        state = L2aAuthState.recovery(
          UserProfile(email: session?.user.email ?? ''),
        );
        return;
      }

      if (session?.user != null) {
        state = L2aAuthState.authenticated(
          UserProfile(email: session!.user.email ?? ''),
        );
      } else {
        state = const L2aAuthState.unauthenticated();
      }
    });
  }

  /// Cancel the password recovery flow and return to unauthenticated state.
  void cancelRecovery() {
    state = const L2aAuthState.unauthenticated();
  }

  Future<void> signIn(String email, String password) async {
    // Do not set loading here to avoid router redirecting to splash mid-action.
    try {
      await _supabase.signInWithEmail(email: email, password: password);
      // onAuthStateChange will update state to authenticated on success.
    } catch (e) {
      state = const L2aAuthState.unauthenticated();
      rethrow;
    }
  }

  Future<void> signUp(
    String email,
    String password, {
    String? redirectTo,
  }) async {
    // Do not set loading here; remain unauthenticated during the signup request.
    try {
      await _supabase.signUpWithEmail(
        email: email,
        password: password,
        redirectTo: redirectTo,
      );
      // After sign-up with email verification, there is usually no session.
      // Keep the user unauthenticated so routing can proceed to verification.
      state = const L2aAuthState.unauthenticated();
    } catch (e) {
      state = const L2aAuthState.unauthenticated();
      rethrow;
    }
  }

  Future<void> sendOtp(String email) async {
    await _supabase.sendOtp(email: email);
  }

  Future<void> sendMagicLink(String email, {String? redirectTo}) async {
    await _supabase.sendMagicLink(email: email, redirectTo: redirectTo);
  }

  Future<void> resetPassword(String email, {String? redirectTo}) async {
    await _supabase.resetPassword(email: email, redirectTo: redirectTo);
  }

  Future<void> updatePassword(String newPassword) async {
    await _supabase.updatePassword(newPassword: newPassword);
    final user = _supabase.currentUser;
    if (user != null) {
      state = L2aAuthState.authenticated(UserProfile(email: user.email ?? ''));
    } else {
      state = const L2aAuthState.unauthenticated();
    }
  }

  Future<void> signOut() async {
    state = const L2aAuthState.unauthenticated();
    try {
      await _supabase.signOut();
    } catch (_) {}
  }
}
