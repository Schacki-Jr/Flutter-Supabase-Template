// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Flutter Supabase Beispiel';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get loginAction => 'Login';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get noAccount => 'Kein Konto?';

  @override
  String get registerAction => 'Registrieren';

  @override
  String errorLoginFailed(Object error) {
    return 'Login fehlgeschlagen: $error';
  }

  @override
  String get valEnterEmail => 'Bitte E-Mail eingeben';

  @override
  String get valInvalidEmail => 'Ungültige E-Mail';

  @override
  String get valEnterPassword => 'Bitte Passwort eingeben';

  @override
  String get valMinPassword => 'Mindestens 8 Zeichen';
}
