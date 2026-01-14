import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_supabase_template/features/auth/providers/update_password_controller.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/widgets/app_button.dart';
import 'package:flutter_supabase_template/shared/widgets/app_form.dart';
import 'package:flutter_supabase_template/shared/widgets/app_text_field.dart';
import 'package:flutter_supabase_template/shared/widgets/center_panel.dart';

class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  ConsumerState<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends ConsumerState<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  // Loading is now handled via UpdatePasswordController's AsyncValue

  @override
  void dispose() {
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  String? _passwordValidator(String? value) {
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return loc.valEnterPassword;
    if (value.length < 8) return loc.valMinPassword;
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_password.text != _password2.text) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.passwordsMismatch)),
      );
      return;
    }
    await ref
        .read(updatePasswordControllerProvider.notifier)
        .submit(_password.text);
  }

  void _cancel() {
    // Exit recovery flow and go back to login
    ref.read(authProvider.notifier).cancelRecovery();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      const LoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for async success/error to notify and navigate
    final loc = AppLocalizations.of(context)!;
    ref.listen(updatePasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.passwordUpdated)),
            );
            const HomeRoute().go(context);
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.errorGeneric(err.toString()))),
          );
        },
      );
    });

    final updating = ref.watch(updatePasswordControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.newPasswordTitle)),
      body: CenterPanel(
        child: AppForm(
          formKey: _formKey,
          children: [
            Text(loc.setNewPasswordInfo),
            AppTextField(
              label: loc.newPasswordLabel,
              controller: _password,
              obscureText: true,
              validator: _passwordValidator,
            ),
            AppTextField(
              label: loc.repeatPasswordLabel,
              controller: _password2,
              obscureText: true,
              validator: _passwordValidator,
            ),
            AppButton(
              label: loc.savePasswordAction,
              onPressed: _submit,
              loading: updating.isLoading,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: updating.isLoading ? null : _cancel,
              child: Text(loc.cancelAction),
            ),
          ],
        ),
      ),
    );
  }
}
