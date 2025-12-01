import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/utils/firebase_utils.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_bloc.freezed.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ImageService _imageService;
  final ProfileRepository _profileRepository;

  EditProfileBloc({
    required ImageService imageService,
    required ProfileRepository profileRepository,
  }) : _imageService = imageService,
      _profileRepository = profileRepository,
        super(EditProfileState.idle()) {
    on<EditProfileEvent>((event, emit) async {
      await event.map(
          usernameChanged: (_UsernameChanged event) => _usernameChanged(event, emit),
          bioChanged: (_BioChanged event) => _bioChanged(event, emit),
          selectImage: (_SelectImage event) => _selectImage(event, emit),
          getUserInfo: (_) => _getUserInfo(emit),
          saveProfile: (_) => _saveProfile(emit),
      );
    });
  }

  factory EditProfileBloc.getUserInfo({
    required ImageService imageService,
    required ProfileRepository profileRepository,
  }) => EditProfileBloc(
      imageService: imageService,
      profileRepository: profileRepository
  )..add(EditProfileEvent.getUserInfo());

  _usernameChanged(_UsernameChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(username: event.username));
    debugPrint('--- ${state.username}');
  }

  _bioChanged(_BioChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(bio: event.bio));
  }

  _selectImage(_SelectImage event, Emitter<EditProfileState> emit) async {
    emit(EditProfileState.processing());

    try {
      final res = await _imageService.pickImage(event.isCamera);

      emit(EditProfileState.success(imageFile: res));
    } catch(e) {
      emit(EditProfileState.failed());
    }
  }

  _saveProfile(Emitter<EditProfileState> emit) async {
    emit(EditProfileState.processing(
      imageFile: state.imageFile,
      username: state.username,
      bio: state.bio,
    ));
    try {
      debugPrint(" --- _saveProfile ${state.username} ${state.bio}");
      await _profileRepository.updateUserInfo(
          image: state.imageFile ?? File(''),
          username: state.username,
          bio: state.bio,
      );
      emit(EditProfileState.success());
    } catch(e) {
      emit(EditProfileState.failed());
    }
  }

  _getUserInfo(Emitter<EditProfileState> emit) async {
    emit(EditProfileState.processing(
      username: "123",
      bio: state.username,
    ));
    debugPrint(" ---${state.username} ${state.bio}");
    try {
      final user = await DbProvider.db.getClient(FirebaseUtils.currentUser);

      emit(EditProfileState.success(
        username: user.username,
        bio: user.bio,

      ));
      debugPrint("--- ${state.username} ${state.bio}");
    } catch (e) {
      emit(EditProfileState.failed());
    }
  }
}
