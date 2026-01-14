import 'package:flutter_supabase_template/features/auth/models/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class L2aAuthState with _$L2aAuthState {
  const factory L2aAuthState.loading() = _Loading;
  const factory L2aAuthState.unauthenticated() = _Unauthenticated;
  const factory L2aAuthState.authenticated(UserProfile profile) =
      _Authenticated;
  const factory L2aAuthState.recovery(UserProfile profile) = _Recovery;
}
