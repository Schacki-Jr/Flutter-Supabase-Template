import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_supabase_template/features/auth/providers/reset_otp_controller.dart';
import 'package:flutter_supabase_template/features/auth/widgets/shad_otp_input.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/widgets/app_button.dart';
import 'package:flutter_supabase_template/shared/widgets/app_form.dart';
import 'package:flutter_supabase_template/shared/widgets/app_text_field.dart';
import 'package:flutter_supabase_template/shared/widgets/center_panel.dart';

class ResetOtpScreen extends ConsumerStatefulWidget {
  const ResetOtpScreen({super.key});

  @override
  ConsumerState<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends ConsumerState<ResetOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String _otp = '';

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_otp.length != 6) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.otpEnter6DigitsOtp)),
      );
      return;
    }
    await ref
        .read(resetOtpControllerProvider.notifier)
        .submit(_email.text.trim(), _otp.trim());
  }

  void _cancel() {
    // Clear flow state and navigate back or to login
    ref.read(pendingEmailProvider.notifier).set(null);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      const LoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingEmail = ref.watch(pendingEmailProvider);
    final loc = AppLocalizations.of(context)!;
    if (pendingEmail != null && _email.text.isEmpty) {
      _email.text = pendingEmail;
    }
    // Listen for async success/error to notify and navigate
    ref.listen(resetOtpControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (mounted) {
            const UpdatePasswordRoute().go(context);
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.verificationFailed(err.toString()))),
          );
        },
      );
    });

    final verifying = ref.watch(resetOtpControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.resetOtpTitle)),
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
            Text(loc.enterCode6Prompt),
            ShadOtpInput(
              length: 6,
              onChanged: (code) => _otp = code,
              onCompleted: (_) => _verify(),
            ),
            AppButton(
              label: loc.confirmAction,
              onPressed: _verify,
              loading: verifying.isLoading,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: verifying.isLoading ? null : _cancel,
              child: Text(loc.cancelAction),
            ),
          ],
        ),
      ),
    );
  }
}
