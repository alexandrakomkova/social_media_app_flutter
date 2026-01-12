part of 'sign_in_bloc.dart';

@freezed
sealed class SignInState with _$SignInState {
  const SignInState._();

  const factory SignInState.idle({
    @Default('') String email,
    @Default('') String password,
  }) = SignInState$Idle;

  const factory SignInState.processing({
    @Default('') String email,
    @Default('') String password,
  }) = SignInState$Processing;

  const factory SignInState.success({
    @Default('') String email,
    @Default('') String password,
  }) = SignInState$Success;

  const factory SignInState.failed({
    @Default('') String email,
    @Default('') String password,
    @Default('') String errorMessage,
  }) = SignInState$Failed;
}
