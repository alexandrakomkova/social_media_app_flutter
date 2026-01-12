import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

part 'sign_up_bloc.freezed.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;

  SignUpBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignUpState.idle()) {
    on<SignUpEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_UsernameChanged):
          await _usernameChanged(event as _UsernameChanged, emit);
        case const (_EmailChanged):
          await _emailChanged(event as _EmailChanged, emit);
        case const (_PasswordChanged):
          await _passwordChanged(event as _PasswordChanged, emit);
        case const (_RepeatPasswordChanged):
          await _repeatPasswordChanged(event as _RepeatPasswordChanged, emit);
        case const (_SignUp):
          await _signUp(emit);
      }
    });
  }

  Future<void> _usernameChanged(
    _UsernameChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(username: event.username));
  }

  Future<void> _emailChanged(
    _EmailChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _passwordChanged(
    _PasswordChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _repeatPasswordChanged(
    _RepeatPasswordChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(repeatPassword: event.repeatPassword));
  }

  Future<void> _signUp(Emitter<SignUpState> emit) async {
    emit(
      SignUpState.processing(
        username: state.username,
        email: state.email,
        password: state.password,
        repeatPassword: state.repeatPassword,
      ),
    );

    try {
      final user = UserModel(
        username: state.username,
        email: state.email,
        password: state.password,
        creationTimestamp: DateTime.now().millisecondsSinceEpoch,
      );
      final res = await _authRepository.signUp(user);

      res.fold(
        (onError) {
          final String errorMessage = onError.error is FirebaseAuthException
              ? (onError.error as FirebaseAuthException).message ?? ''
              : 'An unexpected error occurred';

          emit(
            SignUpState.failed(
              username: state.username,
              email: state.email,
              password: state.password,
              repeatPassword: state.repeatPassword,
              errorMessage: errorMessage,
            ),
          );
        },
        (onOk) {
          emit(
            SignUpState.success(
              username: state.username,
              email: state.email,
              password: state.password,
              repeatPassword: state.repeatPassword,
            ),
          );
        },
      );
    } catch (e) {
      final String errorMessage = e is FirebaseAuthException
          ? e.message ?? 'Unknown error'
          : 'An unexpected error occurred';

      emit(
        SignUpState.failed(
          username: state.username,
          email: state.email,
          password: state.password,
          repeatPassword: state.repeatPassword,
          errorMessage: errorMessage,
        ),
      );
    }
  }
}
