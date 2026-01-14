import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CenterPanel extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry outerPadding;
  final EdgeInsetsGeometry innerPadding;

  const CenterPanel({
    super.key,
    required this.child,
    this.maxWidth = 420,
    this.outerPadding = const EdgeInsets.all(16),
    this.innerPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: outerPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ShadCard(
                  width: maxWidth,
                  child: Padding(
                    padding: innerPadding,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

