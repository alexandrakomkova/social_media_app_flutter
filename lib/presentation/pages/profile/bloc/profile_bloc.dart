import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc({
    required AuthRepository authRepository
  }) : _authRepository = authRepository, super(const ProfileState.idle()) {
    on<ProfileEvent>((events, emit) async {
      await events.map(
        signOut: (_) => _signOut(emit),
        getUserInfo: (event) => _getUserInfo(event, emit),
      );
    });
  }

  factory ProfileBloc.getUserInfo({
    required AuthRepository authRepository,
    required String? id,
  }) => ProfileBloc(authRepository: authRepository)..add(ProfileEvent.getUserInfo(id!));

  Future<void> _signOut(Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
      await _authRepository.signOut();

      emit(ProfileState.success());
    } catch(e) {
      emit(ProfileState.failed());
    }
  }

  _getUserInfo(event, Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
     final user =  await _authRepository.getUserInfo(event.id);

     debugPrint('--- ${user?.email}');
      emit(ProfileState.success(user: user));
    } catch(e) {
      emit(ProfileState.failed());
    }
  }
}
