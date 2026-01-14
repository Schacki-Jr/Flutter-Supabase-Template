import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/core/scaffold_messenger.dart';
import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_supabase_template/features/auth/providers/signup_controller.dart';
import 'package:flutter_supabase_template/features/auth/screens/register_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/verify_email_screen.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class _OkSignupController extends SignupController {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  @override
  Future<void> submit(
    String email,
    String password, {
    String? redirectTo,
  }) async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const AsyncData(null);
  }
}

void main() {
  testWidgets(
      'Successful registration navigates to /verify and stores pending email',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
        GoRoute(path: '/verify', builder: (_, __) => const VerifyEmailScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signupControllerProvider.overrideWith(() => _OkSignupController()),
        ],
        child: ShadApp.router(
          routerConfig: router,
          builder: (context, child) => ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: child!,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    // Enter email/password
    await tester.pump();
    final emailField = find.descendant(
      of: find.byType(ShadInput).at(0),
      matching: find.byType(EditableText),
    );
    final passwordField = find.descendant(
      of: find.byType(ShadInput).at(1),
      matching: find.byType(EditableText),
    );
    await tester.enterText(emailField, 'new@example.com');
    await tester.enterText(passwordField, 'password123');

    // Tap Account erstellen
    await tester.tap(find.byType(ShadButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Pending email should be set
    final scope = ProviderScope.containerOf(
      tester.element(find.byType(VerifyEmailScreen)),
    );
    expect(scope.read(pendingEmailProvider), 'new@example.com');
  });
}
