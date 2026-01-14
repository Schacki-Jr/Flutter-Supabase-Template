import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/features/auth/screens/login_screen.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Shows validation errors on empty submit', (tester) async {
    // No error handler override needed after layout fix
    await tester.pumpWidget(
      const ProviderScope(
        child: _LocalizedApp(child: LoginScreen()),
      ),
    );

    final loginButton = find.byType(ShadButton);
    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Bitte E-Mail eingeben'), findsOneWidget);
    expect(find.text('Bitte Passwort eingeben'), findsOneWidget);
  });
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
        home: child,
      ),
    );
  }
}
