import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/flow_providers.dart';
import 'package:flutter_supabase_template/features/auth/providers/signup_controller.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/validators.dart';
import 'package:flutter_supabase_template/shared/widgets/app_button.dart';
import 'package:flutter_supabase_template/shared/widgets/app_form.dart';
import 'package:flutter_supabase_template/shared/widgets/app_text_field.dart';
import 'package:flutter_supabase_template/shared/widgets/center_panel.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  // Loading is now handled via SignupController's AsyncValue

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
    await ref.read(signupControllerProvider.notifier).submit(
          _email.text.trim(),
          _password.text,
          // Provide your hosted redirect URL (deep link / universal link)
          redirectTo: null,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for async errors/success to show messages or navigate
    final loc = AppLocalizations.of(context)!;
    ref.listen(signupControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          final email = _email.text.trim();
          if (mounted) {
            ref.read(pendingEmailProvider.notifier).set(email);
            const VerifyRoute().push(context);
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.registerError(err.toString()))),
          );
        },
      );
    });

    final signup = ref.watch(signupControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.registerTitle)),
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
            AppTextField(
              label: loc.passwordLabel,
              controller: _password,
              obscureText: true,
              validator: _passwordValidator,
            ),
            AppButton(
              label: loc.createAccountAction,
              onPressed: _submit,
              loading: signup.isLoading,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                Text(loc.alreadyHaveAccount),
                TextButton(
                  onPressed: () => const LoginRoute().go(context),
                  child: Text(loc.loginAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
