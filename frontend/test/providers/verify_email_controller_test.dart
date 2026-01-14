import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_supabase_template/features/auth/providers/verify_email_controller.dart';
import 'package:flutter_supabase_template/shared/services/supabase_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VerifyEmailController', () {
    test('success sets AsyncData and calls service', () async {
      final calls = <List<String>>[];
      final container = ProviderContainer(
        overrides: [
          supabaseServiceProvider.overrideWithValue(
            _FakeSupabase(
              onVerifyEmail: (email, token) async => calls.add([email, token]),
            ) as SupabaseService,
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(verifyEmailControllerProvider.notifier);
      await notifier.submit('user@example.com', '123456');
      expect(container.read(verifyEmailControllerProvider).hasError, isFalse);
      expect(calls, [
        ['user@example.com', '123456'],
      ]);
    });

    test('failure sets AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          supabaseServiceProvider.overrideWithValue(
            _FakeSupabase(
              onVerifyEmail: (email, token) async => throw Exception('nope'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(verifyEmailControllerProvider.notifier);
      await notifier.submit('user@example.com', '000000');
      expect(container.read(verifyEmailControllerProvider).hasError, isTrue);
    });
  });
}

class _FakeSupabase extends SupabaseService {
  _FakeSupabase({required this.onVerifyEmail});

  final Future<void> Function(String email, String token) onVerifyEmail;

  @override
  Future<void> verifyEmailOtp({required String email, required String token}) =>
      onVerifyEmail(email, token);
}
