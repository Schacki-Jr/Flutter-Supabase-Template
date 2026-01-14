import 'package:flutter/material.dart';
import 'package:flutter_supabase_template/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.splashLoading),
          ],
        ),
      ),
    );
  }
}
