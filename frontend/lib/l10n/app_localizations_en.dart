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

  @override
  String get splashLoading => 'Loading...';

  @override
  String get otpEnter6Digits => 'Please enter a 6-digit code';

  @override
  String get otpEnter6DigitsOtp => 'Please enter a 6-digit OTP code';

  @override
  String verificationFailed(Object error) {
    return 'Verification failed: $error';
  }

  @override
  String get resetOtpTitle => 'Enter reset OTP';

  @override
  String emailDisplay(String email) {
    return 'Email: $email';
  }

  @override
  String get enterCode6Prompt => 'Enter code (6 digits):';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get resetLinkSent => 'Reset link sent. Check email or use OTP.';

  @override
  String resetError(Object error) {
    return 'Reset failed: $error';
  }

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get sendResetLinkAction => 'Send reset link';

  @override
  String get homeTitle => 'Home';

  @override
  String get logoutTooltip => 'Logout';

  @override
  String get welcome => 'Welcome!';

  @override
  String welcomeWithEmail(String email) {
    return 'Welcome, $email!';
  }

  @override
  String get verifyEmailTitle => 'Verify email';

  @override
  String get otpPrompt6 => 'Enter OTP (6 digits):';

  @override
  String get magicLinkHint => 'Or click the magic link in your email.';

  @override
  String get emailVerified => 'Email verified.';

  @override
  String registerError(Object error) {
    return 'Registration failed: $error';
  }

  @override
  String get registerTitle => 'Register';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get passwordsMismatch => 'Passwords do not match';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String errorGeneric(Object error) {
    return 'Error: $error';
  }

  @override
  String get newPasswordTitle => 'Set new password';

  @override
  String get setNewPasswordInfo => 'Please set a new password (after password reset link).';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get repeatPasswordLabel => 'Repeat password';

  @override
  String get savePasswordAction => 'Save password';

  @override
  String get verifyAction => 'Verify';
}
