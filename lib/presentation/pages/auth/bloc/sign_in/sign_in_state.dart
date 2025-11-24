part of 'sign_in_bloc.dart';
enum SignInStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class SignInState with _$SignInState {
  const SignInState._();

  const factory SignInState.idle({
    @Default('') String email,
    @Default('') String password,
    @Default(SignInStatus.idle) SignInStatus status,
  }) = SignInState$Idle;

  const factory SignInState.processing({
    @Default('') String email,
    @Default('') String password,
    @Default(SignInStatus.processing) SignInStatus status,
  }) = SignInState$Processing;

  const factory SignInState.success({
    @Default('') String email,
    @Default('') String password,
    @Default(SignInStatus.success) SignInStatus status,
  }) = SignInState$Success;

  const factory SignInState.failed({
    @Default('') String email,
    @Default('') String password,
    @Default(SignInStatus.failed) SignInStatus status,
  }) = SignInState$Failed;
}