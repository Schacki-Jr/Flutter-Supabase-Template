import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/core/scaffold_messenger.dart';
import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_supabase_template/features/auth/providers/reset_password_controller.dart';
import 'package:flutter_supabase_template/features/auth/screens/reset_otp_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/reset_password_screen.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class _OkResetPasswordController extends ResetPasswordController {
  @override
  FutureOr<void> build() {}
  @override
  Future<void> submit(String email, {String? redirectTo}) async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const AsyncData(null);
  }
}

void main() {
  testWidgets(
      'Reset password sends link, sets pending email, navigates to /reset-otp',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/reset',
      routes: [
        GoRoute(
          path: '/reset',
          builder: (_, __) => const ResetPasswordScreen(),
        ),
        GoRoute(path: '/reset-otp', builder: (_, __) => const ResetOtpScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          resetPasswordControllerProvider
              .overrideWith(() => _OkResetPasswordController()),
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

    // Enter email
    await tester.pump();
    final emailField = find.descendant(
      of: find.byType(ShadInput).at(0),
      matching: find.byType(EditableText),
    );
    await tester.enterText(emailField, 'reset@example.com');

    // Tap Reset-Link senden
    await tester.tap(find.byType(ShadButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Navigation + pending email + SnackBar visible
    final scope =
        ProviderScope.containerOf(tester.element(find.byType(ResetOtpScreen)));
    expect(scope.read(pendingEmailProvider), 'reset@example.com');
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
