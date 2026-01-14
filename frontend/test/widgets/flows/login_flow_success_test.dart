import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/core/scaffold_messenger.dart';
import 'package:flutter_supabase_template/features/auth/providers/login_controller.dart';
import 'package:flutter_supabase_template/features/auth/screens/login_screen.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class _OkLoginController extends LoginController {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  @override
  Future<void> submit(String email, String password) async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const AsyncData(null);
  }
}

class _DummyHome extends StatelessWidget {
  const _DummyHome();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('HOME OK')));
}

void main() {
  testWidgets('Successful login navigates to /home', (tester) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/home', builder: (_, __) => const _DummyHome()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginControllerProvider.overrideWith(() => _OkLoginController()),
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

    // Enter valid credentials
    await tester.pump();
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

    // Tap Login
    await tester.tap(find.byType(ShadButton));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('HOME OK'), findsOneWidget);
  });
}
