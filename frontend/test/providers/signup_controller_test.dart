import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/features/auth/models/auth_state.dart';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_supabase_template/features/auth/providers/signup_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignupController', () {
    test('submit success sets AsyncData and calls signUp', () async {
      final calls = <List<String?>>[];
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            () => _TestAuth(
              onSignUp: (email, password, redirectTo) async {
                calls.add([email, password, redirectTo]);
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupControllerProvider.notifier);

      await notifier.submit(
        ' user@example.com ',
        'password123',
        redirectTo: 'https://example.com',
      );

      expect(container.read(signupControllerProvider), isA<AsyncData<void>>());
      expect(calls, [
        [' user@example.com ', 'password123', 'https://example.com'],
      ]);
    });

    test('submit failure sets AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            () => _TestAuth(
              onSignUp: (email, password, redirectTo) async {
                throw Exception('fail');
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupControllerProvider.notifier);
      await notifier.submit('user@example.com', 'password123');
      expect(container.read(signupControllerProvider).hasError, isTrue);
    });
  });
}

class _TestAuth extends Auth {
  _TestAuth({required this.onSignUp});

  final Future<void> Function(String email, String password, String? redirectTo)
      onSignUp;

  @override
  L2aAuthState build() => const L2aAuthState.unauthenticated();

  @override
  Future<void> signUp(String email, String password, {String? redirectTo}) =>
      onSignUp(email, password, redirectTo);
}
