part of 'sign_up_bloc.dart';

enum SignUpStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class SignUpState with _$SignUpState{
  const SignUpState._();

  const factory SignUpState.idle({
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
    @Default(SignUpStatus.idle) SignUpStatus status,
  }) = SignUpState$Idle;

  const factory SignUpState.processing({
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
    @Default(SignUpStatus.processing) SignUpStatus status,
  }) = SignUpState$Processing;

  const factory SignUpState.success({
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
    @Default(SignUpStatus.success) SignUpStatus status,
  }) = SignUpState$Success;

  const factory SignUpState.failed({
    @Default('') String email,
    @Default('') String password,
    @Default('') String repeatPassword,
    @Default(SignUpStatus.failed) SignUpStatus status,
  }) = SignUpState$Failed;
}