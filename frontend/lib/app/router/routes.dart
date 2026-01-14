import 'package:flutter/widgets.dart';
import 'package:flutter_supabase_template/app/core/home_screen.dart';
import 'package:flutter_supabase_template/app/core/splash_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/login_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/register_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/reset_otp_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/reset_password_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/update_password_screen.dart';
import 'package:flutter_supabase_template/features/auth/screens/verify_email_screen.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(
  path: '/splash',
)
class SplashRoute extends GoRouteData with _$SplashRoute {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}

@TypedGoRoute<LoginRoute>(
  path: '/login',
)
class LoginRoute extends GoRouteData with _$LoginRoute {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<RegisterRoute>(
  path: '/register',
)
class RegisterRoute extends GoRouteData with _$RegisterRoute {
  const RegisterRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}

@TypedGoRoute<ResetRoute>(
  path: '/reset',
)
class ResetRoute extends GoRouteData with _$ResetRoute {
  const ResetRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResetPasswordScreen();
}

@TypedGoRoute<VerifyRoute>(
  path: '/verify',
)
class VerifyRoute extends GoRouteData with _$VerifyRoute {
  const VerifyRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const VerifyEmailScreen();
}

@TypedGoRoute<ResetOtpRoute>(
  path: '/reset-otp',
)
class ResetOtpRoute extends GoRouteData with _$ResetOtpRoute {
  const ResetOtpRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResetOtpScreen();
}

@TypedGoRoute<UpdatePasswordRoute>(
  path: '/update-password',
)
class UpdatePasswordRoute extends GoRouteData with _$UpdatePasswordRoute {
  const UpdatePasswordRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UpdatePasswordScreen();
}

@TypedGoRoute<HomeRoute>(
  path: '/home',
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}
