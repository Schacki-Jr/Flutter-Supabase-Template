import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/core/scaffold_messenger.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/login_controller.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';
import 'package:flutter_supabase_template/shared/validators.dart';
import 'package:flutter_supabase_template/shared/widgets/app_button.dart';
import 'package:flutter_supabase_template/shared/widgets/app_form.dart';
import 'package:flutter_supabase_template/shared/widgets/app_text_field.dart';
import 'package:flutter_supabase_template/shared/widgets/center_panel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  // ref.listen must be used inside build in Riverpod 2.6+

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
    await ref
        .read(loginControllerProvider.notifier)
        .submit(_email.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Listen for async errors/success to show messages or navigate
    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) const HomeRoute().go(context);
          });
        },
        error: (err, _) {
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(content: Text(loc.errorLoginFailed(err.toString()))),
            );
          });
        },
      );
    });
    final login = ref.watch(loginControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(loc.loginTitle)),
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
              label: loc.loginAction,
              onPressed: _submit,
              loading: login.isLoading,
            ),
            TextButton(
              onPressed: () => const ResetRoute().push(context),
              child: Text(loc.forgotPassword),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                Text(loc.noAccount),
                TextButton(
                  onPressed: () => const RegisterRoute().go(context),
                  child: Text(loc.registerAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
