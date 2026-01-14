// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Supabase Sample';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginAction => 'Login';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'No account?';

  @override
  String get registerAction => 'Register';

  @override
  String errorLoginFailed(Object error) {
    return 'Login failed: $error';
  }

  @override
  String get valEnterEmail => 'Please enter an email';

  @override
  String get valInvalidEmail => 'Invalid email';

  @override
  String get valEnterPassword => 'Please enter a password';

  @override
  String get valMinPassword => 'At least 8 characters';
}
