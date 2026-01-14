import 'package:flutter/material.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('validateEmail covers required, invalid, valid', (tester) async {
    BuildContext? captured;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final ctx = captured!;

    const req = 'Bitte E-Mail eingeben';
    const invalid = 'Ungültige E-Mail';

    expect(validateEmail(ctx, null, requiredMessage: req), req);
    expect(validateEmail(ctx, '', requiredMessage: req), req);

    expect(
      validateEmail(ctx, 'not-an-email', invalidMessage: invalid),
      invalid,
    );
    expect(validateEmail(ctx, 'a@b', invalidMessage: invalid), invalid);

    // Valid email returns null
    expect(validateEmail(ctx, 'test@example.com'), isNull);
  });
}
