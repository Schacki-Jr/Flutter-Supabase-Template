import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_template/app/router/routes.dart';
import 'package:flutter_supabase_template/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final auth = ref.watch(authProvider);

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final goingTo = state.uri.toString();
    final isAuthRoute = goingTo.startsWith('/login') ||
        goingTo.startsWith('/register') ||
        goingTo.startsWith('/reset') ||
        goingTo.startsWith('/verify') ||
        goingTo.startsWith('/reset-otp');

    // If in password recovery, force update-password screen
    final recoveryRedirect = auth.maybeWhen(
      recovery: (_) =>
          goingTo == '/update-password' ? null : '/update-password',
      orElse: () => null,
    );
    if (recoveryRedirect != null) return recoveryRedirect;

    return auth.when(
      loading: () {
        // While loading, allow staying on auth-related routes to avoid
        // being yanked to splash during login/signup/reset flows.
        if (isAuthRoute || goingTo == '/update-password') return null;
        return goingTo == '/splash' ? null : '/splash';
      },
      unauthenticated: () {
        if (isAuthRoute || goingTo == '/update-password') {
          return null; // allow reaching update-password only if recovery happens
        }
        return '/login';
      },
      authenticated: (_) {
        if (isAuthRoute || goingTo == '/splash' || goingTo == '/') {
          return '/home';
        }
        return null;
      },
      recovery: (_) =>
          goingTo == '/update-password' ? null : '/update-password',
    );
  }

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _RouterListenable(ref),
    routes: $appRoutes,
    redirect: redirectLogic,
  );
}

class _RouterListenable extends ChangeNotifier {
  _RouterListenable(Ref ref) {
    ref.listen(
      authProvider,
      (_, __) => notifyListeners(),
      fireImmediately: true,
    );
  }
}
