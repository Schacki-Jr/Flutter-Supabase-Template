import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // Use ShadInput, but keep controller/validator support via FormField wrapper
    return FormField<String>(
      autovalidateMode: AutovalidateMode.disabled,
      validator: validator,
      initialValue: controller.text,
      builder: (state) {
        final errorText = state.errorText;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: ShadTheme.of(context).textTheme.muted),
            const SizedBox(height: 6),
            ShadInput(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              placeholder: Text(label),
              onChanged: (v) => state.didChange(v),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 6),
              Text(
                errorText,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}

