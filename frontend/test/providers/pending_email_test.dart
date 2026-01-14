import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('PendingEmail set/get works', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(pendingEmailProvider), isNull);
    container.read(pendingEmailProvider.notifier).set('user@example.com');
    expect(container.read(pendingEmailProvider), 'user@example.com');
    container.read(pendingEmailProvider.notifier).set(null);
    expect(container.read(pendingEmailProvider), isNull);
  });
}
