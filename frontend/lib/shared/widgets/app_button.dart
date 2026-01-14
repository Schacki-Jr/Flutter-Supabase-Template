import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum AppButtonStyle { primary, secondary }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = style == AppButtonStyle.primary;

    final child = loading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              // Text kept outside to avoid color mismatch during loading
            ],
          )
        : Text(label);

    final button = isPrimary
        ? ShadButton(
            onPressed: loading ? null : onPressed,
            child: child,
          )
        : ShadButton.outline(
            onPressed: loading ? null : onPressed,
            child: child,
          );

    return SizedBox(width: double.infinity, height: 48, child: button);
  }
}

