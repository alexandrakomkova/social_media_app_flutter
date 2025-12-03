import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  }) : _authRepository = authRepository,
       _profileRepository = profileRepository,
       super(const ProfileState.idle()) {
    on<ProfileEvent>((events, emit) async {
      await events.map(
        signOut: (_) => _signOut(emit),
        getUserInfo: (event) => _getUserInfo(event, emit),
        getUserPosts: (event) => _getUserPosts(event, emit),
        getUserProfile: (event) => _getUserProfile(event, emit),
      );
    }, transformer: sequential()
    );
  }

  factory ProfileBloc.getUserProfile({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required String? id,
  }) => ProfileBloc(
      authRepository: authRepository,
    profileRepository: profileRepository
  )..add(ProfileEvent.getUserProfile(id));

  Future<void> _signOut(Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
      await _authRepository.signOut();

      emit(ProfileState.success());
    } catch(e) {
      emit(ProfileState.failed());
    }
  }

  _getUserInfo(_GetUserInfo event, Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
     final user =  await _profileRepository.getUserInfo(event.id);

     // debugPrint('--- ${user?.email}');
      emit(ProfileState.success(user: user));
    } catch(e) {
      emit(ProfileState.failed());
    }
  }

  _getUserPosts(_GetUserPosts event, Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
      final res = await _profileRepository.getUserPosts(event.userId);

      emit(ProfileState.success(
        posts: res,
      ));
    } catch(e) {
      emit(ProfileState.failed(
        posts: []
      ));
    }
  }

  _getUserProfile(_GetUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
      final res = await _profileRepository.getUserPosts(event.userId);
      final user =  await _profileRepository.getUserInfo(event.userId);

      emit(ProfileState.success(
        posts: res,
        user: user,
      ));
    } catch(e) {
      emit(ProfileState.failed(
          posts: [],
      ));
    }
  }
}
