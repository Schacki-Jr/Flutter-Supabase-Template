import 'package:flutter/widgets.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';

final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateEmail(
  BuildContext context,
  String? value, {
  String? requiredMessage,
  String? invalidMessage,
}) {
  final loc = AppLocalizations.of(context);
  final String reqMsg =
      requiredMessage ?? loc?.valEnterEmail ?? 'Please enter an email';
  final String invalidMsg =
      invalidMessage ?? loc?.valInvalidEmail ?? 'Invalid email';

  if (value == null || value.isEmpty) return reqMsg;
  if (!_emailRegex.hasMatch(value)) return invalidMsg;
  return null;
}
