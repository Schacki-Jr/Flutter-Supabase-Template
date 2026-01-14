import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flow_providers.g.dart';

// Holds the email used in the current auth flow (signup/verification or password reset)
@Riverpod(keepAlive: true)
class PendingEmail extends _$PendingEmail {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

