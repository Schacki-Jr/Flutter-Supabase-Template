import 'package:flutter_supabase_template/features/auth/models/auth_state.dart';
import 'package:flutter_supabase_template/features/auth/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Auth state transitions are representable', () {
    const loading = L2aAuthState.loading();
    expect(loading, isA<L2aAuthState>());

    const unauth = L2aAuthState.unauthenticated();
    expect(unauth, isA<L2aAuthState>());

    const profile = UserProfile(email: 'test@example.com');
    const auth = L2aAuthState.authenticated(profile);
    expect(auth, isA<L2aAuthState>());
  });
}
