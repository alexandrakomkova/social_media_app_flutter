part of 'sign_up_bloc.dart';

@freezed
abstract class SignUpEvent with _$SignUpEvent {
  const SignUpEvent._();
  const factory SignUpEvent.emailChanged(String email) = _EmailChanged;
  const factory SignUpEvent.passwordChanged(String password) = _PasswordChanged;
  const factory SignUpEvent.repeatPasswordChanged(String repeatPassword) = _RepeatPasswordChanged;
  const factory SignUpEvent.signUp() = _SignUp;
}