import 'package:flutter_supabase_template/features/auth/models/auth_state.dart';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_supabase_template/features/auth/providers/login_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('LoginController', () {
    test('submit success transitions to AsyncData', () async {
      final calls = <List<String>>[];
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            () => _TestAuth(
              onSignIn: (email, password) async {
                calls.add([email, password]);
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(loginControllerProvider.notifier);
      final states = <AsyncValue<void>>[];
      final sub = container.listen(
        loginControllerProvider,
        (prev, next) {
          states.add(next);
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      await notifier.submit('  user@example.com  ', 'secret');

      // Last state should be data (not loading/error)
      expect(states.last, isA<AsyncData<void>>());
      // Called once with the provided email
      expect(calls, [
        ['  user@example.com  ', 'secret'],
      ]);
    });

    test('submit failure transitions to AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            () => _TestAuth(
              onSignIn: (email, password) async {
                throw Exception('boom');
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(loginControllerProvider.notifier);

      await notifier.submit('user@example.com', 'secret');

      final state = container.read(loginControllerProvider);
      expect(state.hasError, isTrue);
    });
  });
}

class _TestAuth extends Auth {
  _TestAuth({required this.onSignIn});

  final Future<void> Function(String email, String password) onSignIn;

  @override
  L2aAuthState build() => const L2aAuthState.unauthenticated();

  @override
  Future<void> signIn(String email, String password) =>
      onSignIn(email, password);
}
