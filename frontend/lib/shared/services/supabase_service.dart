import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  // Email + password login
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  // Email + password registration with email verification
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? redirectTo,
  }) async {
    final webRedirect =
        dotenv.env['WEB_REDIRECT_URL'] ?? 'http://localhost:5500/';
    final effectiveRedirect = redirectTo ?? webRedirect;
    return _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: effectiveRedirect,
    );
  }

  // Send OTP to email
  Future<void> sendOtp({required String email}) async {
    await _client.auth.signInWithOtp(email: email);
  }

  // Magic link sign-in
  Future<void> sendMagicLink({
    required String email,
    String? redirectTo,
  }) async {
    final webRedirect =
        dotenv.env['WEB_REDIRECT_URL'] ?? 'http://localhost:5500/';
    final effectiveRedirect = redirectTo ?? webRedirect;
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: effectiveRedirect,
    );
  }

  // Reset password via email
  Future<void> resetPassword({
    required String email,
    String? redirectTo,
  }) async {
    final webRedirect =
        dotenv.env['WEB_REDIRECT_URL'] ?? 'http://localhost:5500/';
    final effectiveRedirect = redirectTo ?? webRedirect;
    await _client.auth
        .resetPasswordForEmail(email, redirectTo: effectiveRedirect);
  }

  // Update password after redirect
  Future<void> updatePassword({required String newPassword}) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Verify OTP for email verification
  Future<void> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    await _client.auth.verifyOTP(
      token: token,
      type: OtpType.email,
      email: email,
    );
  }

  // Verify OTP for password recovery
  Future<void> verifyRecoveryOtp({
    required String email,
    required String token,
  }) async {
    await _client.auth.verifyOTP(
      token: token,
      type: OtpType.recovery,
      email: email,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;
}
