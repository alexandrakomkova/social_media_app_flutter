part of 'sign_up_bloc.dart';

@freezed
sealed class SignUpState with _$SignUpState {
  const SignUpState._();

  const factory SignUpState.idle({
    @Default('') String username,
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
  }) = SignUpState$Idle;

  const factory SignUpState.processing({
    @Default('') String username,
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
  }) = SignUpState$Processing;

  const factory SignUpState.success({
    @Default('') String username,
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
  }) = SignUpState$Success;

  const factory SignUpState.failed({
    @Default('') String username,
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
    @Default('') String errorMessage,
  }) = SignUpState$Failed;
}
