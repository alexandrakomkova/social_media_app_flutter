import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';
part 'sign_in_bloc.freezed.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository, super(const SignInState.idle()) {
    on<SignInEvent>((events, emit) async {
      await events.map(
        emailChanged: (event) => _emailChanged(event, emit),
        passwordChanged: (event) => _passwordChanged(event, emit),
        signIn: (_) => _signIn(emit),
      );
    });
  }

  _emailChanged(event, Emitter<SignInState> emit) {
    emit(state.copyWith(email: event.email));
  }

  _passwordChanged(event, Emitter<SignInState> emit) {
    emit(state.copyWith(password: event.password));
  }

  _signIn(Emitter<SignInState> emit) async {
    emit(SignInState.processing(email: state.email, password: state.password));

    try {
      debugPrint('${state.email}, ${state.password}');
      await _authRepository.signIn(UserModel(
        email: state.email,
        password: state.password,
      ));
      emit(SignInState.success());
    } catch(e) {
      emit(SignInState.failed());
    }
  }
  
  
}
