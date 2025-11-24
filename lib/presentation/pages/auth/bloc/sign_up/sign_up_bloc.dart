import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';
part 'sign_up_bloc.freezed.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;

  SignUpBloc({
    required AuthRepository authRepository
}) : _authRepository = authRepository, super(const SignUpState.idle()) {
    on<SignUpEvent>((events, emit) async {
      await events.map(
          emailChanged: (event) => _emailChanged(event, emit),
          passwordChanged: (event) => _passwordChanged(event, emit),
          repeatPasswordChanged: (event) => _repeatPasswordChanged(event, emit),
          signUp: (_) => _signUp(emit),
      );
    });
  }

  _emailChanged(event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  _passwordChanged(event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  _repeatPasswordChanged(event, Emitter<SignUpState> emit) {
    emit(state.copyWith(repeatPassword: event.repeatPassword));
  }

  _signUp(Emitter<SignUpState> emit) async {
    debugPrint('SignUpBloc _signUp ${state.email} ${state.password}');
    //emit(SignUpState.processing());
    try {
      final user = UserModel(
          email: state.email,
          password: state.password,
      );
      await _authRepository.signUp(user);

      debugPrint('SignUpBloc _signUp success');
      emit(SignUpState.success());
    } catch(e) {
      debugPrint('SignUpBloc _signUp failure');
      emit(SignUpState.failed());
    }
  }
}
