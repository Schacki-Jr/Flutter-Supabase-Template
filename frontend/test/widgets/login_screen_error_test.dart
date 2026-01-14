import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/core/scaffold_messenger.dart';
import 'package:flutter_supabase_template/features/auth/providers/login_controller.dart';
import 'package:flutter_supabase_template/features/auth/screens/login_screen.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  testWidgets('Shows SnackBar on login error', (tester) async {
    // No error handler override needed after layout fix
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginControllerProvider
              .overrideWith(() => _FakeLoginControllerError()),
        ],
        child: const _LocalizedApp(child: LoginScreen()),
      ),
    );

    // Enter valid email and password so form validation passes
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final emailField = find.descendant(
      of: find.byType(ShadInput).at(0),
      matching: find.byType(EditableText),
    );
    final passwordField = find.descendant(
      of: find.byType(ShadInput).at(1),
      matching: find.byType(EditableText),
    );
    await tester.enterText(emailField, 'user@example.com');
    await tester.enterText(passwordField, 'password123');

    // Tap primary ShadButton labeled Login
    await tester.tap(find.byType(ShadButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Expect a SnackBar with localized error prefix in German
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Login fehlgeschlagen'), findsOneWidget);
  });
}

class ShadInput {}

class _FakeLoginControllerError extends LoginController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  @override
  Future<void> submit(String email, String password) async {
    // Immediately emit error state
    state = AsyncError(Exception('bad creds'), StackTrace.current);
  }
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(size: Size(1200, 1000)),
      child: ShadApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: child,
        ),
      ),
    );
  }
}
