import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_supabase_template/features/auth/providers/verify_email_controller.dart';
import 'package:flutter_supabase_template/features/auth/widgets/shad_otp_input.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/widgets/app_button.dart';
import 'package:flutter_supabase_template/shared/widgets/app_form.dart';
import 'package:flutter_supabase_template/shared/widgets/app_text_field.dart';
import 'package:flutter_supabase_template/shared/widgets/center_panel.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String _otp = '';
  // Loading is now handled via VerifyEmailController's AsyncValue

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;
    if (_otp.length != 6) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.otpEnter6Digits)),
      );
      return;
    }
    await ref
        .read(verifyEmailControllerProvider.notifier)
        .submit(_email.text.trim(), _otp.trim());
  }

  @override
  Widget build(BuildContext context) {
    final pendingEmail = ref.watch(pendingEmailProvider);
    final loc = AppLocalizations.of(context)!;
    if (pendingEmail != null && _email.text.isEmpty) {
      _email.text = pendingEmail;
    }
    // Listen for async success/error to notify and navigate
    ref.listen(verifyEmailControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.emailVerified)),
            );
            const LoginRoute().go(context);
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.verificationFailed(err.toString()))),
          );
        },
      );
    });

    final verifying = ref.watch(verifyEmailControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.verifyEmailTitle)),
      body: CenterPanel(
        child: AppForm(
          formKey: _formKey,
          children: [
            if (pendingEmail == null)
              AppTextField(
                label: loc.emailLabel,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || v.isEmpty)
                    ? AppLocalizations.of(context)!.valEnterEmail
                    : null,
              )
            else
              Text(
                loc.emailDisplay(pendingEmail),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8),
            Text(loc.otpPrompt6),
            ShadOtpInput(
              length: 6,
              onChanged: (code) => _otp = code,
              onCompleted: (_) => _verify(),
            ),
            AppButton(
              label: loc.verifyAction,
              onPressed: _verify,
              loading: verifying.isLoading,
            ),
            const Divider(),
            Text(loc.magicLinkHint),
          ],
        ),
      ),
    );
  }
}
