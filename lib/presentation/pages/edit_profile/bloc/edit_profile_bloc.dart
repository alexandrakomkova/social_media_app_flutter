
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/data/db_provider.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/utils/firebase_service.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_bloc.freezed.dart';

final _log = Logger('EditProfileBloc');
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
          deleteImage: (_) => _deleteImage(emit),
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

  Future<void> _usernameChanged(_UsernameChanged event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(username: event.username));
  }

  Future<void> _bioChanged(_BioChanged event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(bio: event.bio));
  }

  Future<void> _selectImage(_SelectImage event, Emitter<EditProfileState> emit) async {
    emit(EditProfileState.processing(
      imageUrl: state.imageUrl,
      username: state.username,
      bio: state.bio,
    ));

    try {
      final res = await _imageService.pickImage(isCamera: event.isCamera);

      emit(EditProfileState.success(
        imageUrl: res?.path ?? '',
        username: state.username,
        bio: state.bio,));
    } catch(e) {
      emit(EditProfileState.failed(
        imageUrl: state.imageUrl,
        username: state.username,
        bio: state.bio,
      ));
    }
  }

  Future<void> _saveProfile(Emitter<EditProfileState> emit) async {
    emit(EditProfileState.processing(
      imageUrl: state.imageUrl,
      username: state.username,
      bio: state.bio,
    ));
    try {
      await _profileRepository.updateUserInfo(
          imageUrl: state.imageUrl,
          username: state.username,
          bio: state.bio,
      );
      emit(EditProfileState.success(
        imageUrl: state.imageUrl,
        username: state.username,
        bio: state.bio,
      ));
    } catch(e) {
      emit(EditProfileState.failed(
        imageUrl: state.imageUrl,
        username: state.username,
        bio: state.bio,
      ));
    }
  }

  Future<void> _getUserInfo(Emitter<EditProfileState> emit) async {
    emit(EditProfileState.processing(
      username: state.username,
      bio: state.bio,
      imageUrl: state.imageUrl
    ));
    try {
      final user = await DbProvider.db.getClient(FirebaseService.currentUserId);

      _log.info('_getUserInfo: ${user.username} ${user.bio}');
      emit(EditProfileState.success(
        username: user.username,
        bio: user.bio,
        imageUrl: user.photoUrl
      ));
    } catch (e) {

      emit(EditProfileState.failed());
    }
  }

  Future<void> _deleteImage(Emitter<EditProfileState> emit) async {
    emit(state.copyWith(imageUrl: ''));
  }
}
