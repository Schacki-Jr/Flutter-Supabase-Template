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

  @override
  String get splashLoading => 'Lade ...';

  @override
  String get otpEnter6Digits => 'Bitte 6-stelligen Code eingeben';

  @override
  String get otpEnter6DigitsOtp => 'Bitte 6-stelligen OTP-Code eingeben';

  @override
  String verificationFailed(Object error) {
    return 'Verifikation fehlgeschlagen: $error';
  }

  @override
  String get resetOtpTitle => 'Reset OTP eingeben';

  @override
  String emailDisplay(String email) {
    return 'E-Mail: $email';
  }

  @override
  String get enterCode6Prompt => 'Code eingeben (6-stellig):';

  @override
  String get confirmAction => 'Bestätigen';

  @override
  String get cancelAction => 'Abbrechen';

  @override
  String get resetLinkSent => 'Reset-Link gesendet. Prüfe E-Mail oder nutze OTP.';

  @override
  String resetError(Object error) {
    return 'Fehler beim Zurücksetzen: $error';
  }

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get sendResetLinkAction => 'Reset-Link senden';

  @override
  String get homeTitle => 'Home';

  @override
  String get logoutTooltip => 'Abmelden';

  @override
  String get welcome => 'Willkommen!';

  @override
  String welcomeWithEmail(String email) {
    return 'Willkommen, $email!';
  }

  @override
  String get verifyEmailTitle => 'E-Mail verifizieren';

  @override
  String get otpPrompt6 => 'OTP eingeben (6-stellig):';

  @override
  String get magicLinkHint => 'Oder klicke auf den Magic Link in deiner E-Mail.';

  @override
  String get emailVerified => 'E-Mail verifiziert.';

  @override
  String registerError(Object error) {
    return 'Registrierung fehlgeschlagen: $error';
  }

  @override
  String get registerTitle => 'Registrieren';

  @override
  String get createAccountAction => 'Account erstellen';

  @override
  String get alreadyHaveAccount => 'Schon ein Konto?';

  @override
  String get passwordsMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordUpdated => 'Passwort aktualisiert';

  @override
  String errorGeneric(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get newPasswordTitle => 'Neues Passwort setzen';

  @override
  String get setNewPasswordInfo => 'Bitte neues Passwort setzen (nach Passwort-Reset-Link).';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get repeatPasswordLabel => 'Passwort wiederholen';

  @override
  String get savePasswordAction => 'Passwort speichern';

  @override
  String get verifyAction => 'Verifizieren';
}
