import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

part 'sign_in_bloc.freezed.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

final _log = Logger('SignInBloc');

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignInState.idle()) {
    on<SignInEvent>((events, emit) async {
      await events.map(
        emailChanged: (event) => _emailChanged(event, emit),
        passwordChanged: (event) => _passwordChanged(event, emit),
        signIn: (_) => _signIn(emit),
        signInWithGoogle: (_) => _signInWithGoogle(emit),
      );
    });
  }

  Future<void> _emailChanged(
    _EmailChanged event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _passwordChanged(
    _PasswordChanged event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _signIn(Emitter<SignInState> emit) async {
    emit(SignInState.processing(email: state.email, password: state.password));

    try {
      final res = await _authRepository.signIn(
        UserModel(email: state.email, password: state.password),
      );

      res.fold(
        (onError) {
          final String errorMessage = onError.error is FirebaseAuthException
              ? (onError.error as FirebaseAuthException).message ?? ''
              : 'An unexpected error occurred';

          _log.warning('-- ${onError.error.toString()}');

          emit(
            SignInState.failed(
              email: state.email,
              password: state.password,
              errorMessage: errorMessage,
            ),
          );
        },
        (onOk) {
          emit(
            SignInState.success(email: state.email, password: state.password),
          );
        },
      );
    } catch (e) {
      final String errorMessage = e is FirebaseAuthException
          ? e.message ?? 'Unknown error'
          : 'An unexpected error occurred';

      _log.warning(e.toString());
      emit(
        SignInState.failed(
          email: state.email,
          password: state.password,
          errorMessage: errorMessage,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(Emitter<SignInState> emit) async {
    emit(SignInState.processing(email: state.email, password: state.password));

    try {
      final res = await _authRepository.signInWithGoogle();

      res.fold(
        (onError) {
          final String errorMessage = onError.error is FirebaseAuthException
              ? (onError.error as FirebaseAuthException).message ?? ''
              : 'An unexpected error occurred';

          emit(
            SignInState.failed(
              email: state.email,
              password: state.password,
              errorMessage: errorMessage,
            ),
          );
        },
        (onOk) {
          emit(
            SignInState.success(email: state.email, password: state.password),
          );
        },
      );
    } catch (e) {
      final String errorMessage = e is FirebaseAuthException
          ? e.message ?? 'Unknown error'
          : 'An unexpected error occurred';

      emit(
        SignInState.failed(
          email: state.email,
          password: state.password,
          errorMessage: errorMessage,
        ),
      );
    }
  }
}
