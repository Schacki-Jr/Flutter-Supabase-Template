import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_supabase_template/features/auth/providers/reset_password_controller.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/validators.dart';
import 'package:flutter_supabase_template/shared/widgets/app_button.dart';
import 'package:flutter_supabase_template/shared/widgets/app_form.dart';
import 'package:flutter_supabase_template/shared/widgets/app_text_field.dart';
import 'package:flutter_supabase_template/shared/widgets/center_panel.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  // Loading is now handled via ResetPasswordController's AsyncValue

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(resetPasswordControllerProvider.notifier).submit(
          _email.text.trim(),
          // Provide redirect URL to your password update screen (deep link)
          redirectTo: null,
        );
  }

  void _cancel() {
    // Clear any pending email saved for the flow and go back to login
    ref.read(pendingEmailProvider.notifier).set(null);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      const LoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for async errors/success to show messages or navigate
    final loc = AppLocalizations.of(context)!;
    ref.listen(resetPasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          final email = _email.text.trim();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.resetLinkSent)),
            );
            ref.read(pendingEmailProvider.notifier).set(email);
            const ResetOtpRoute().push(context);
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.resetError(err.toString()))),
          );
        },
      );
    });

    final reset = ref.watch(resetPasswordControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.resetPasswordTitle)),
      body: CenterPanel(
        child: AppForm(
          formKey: _formKey,
          children: [
            AppTextField(
              label: loc.emailLabel,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => validateEmail(context, v),
            ),
            AppButton(
              label: loc.sendResetLinkAction,
              onPressed: _submit,
              loading: reset.isLoading,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: reset.isLoading ? null : _cancel,
              child: Text(loc.cancelAction),
            ),
          ],
        ),
      ),
    );
  }
}
