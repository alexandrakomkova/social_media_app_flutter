import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/utils/result.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';
part 'create_post_bloc.freezed.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final ImageService _imageService;
  final DbService _dbService;

  CreatePostBloc({
    required ImageService imageService,
    required DbService dbService,
  }) : _imageService = imageService,
        _dbService = dbService,
        super(const CreatePostState.idle()) {
    on<CreatePostEvent>((events, emit) async{
      await events.map(
        postDescriptionChanged: (event) => _postDescriptionChanged(event, emit),
        selectImage: (event) => _selectImage(event, emit),
        createPost: (_) => _createPost(emit),
      );
    });
  }

  Future<void> _postDescriptionChanged(
    _PostDescriptionChanged event,
    Emitter<CreatePostState> emit
  ) async {
    emit(state.copyWith(postDescription: event.postDescription));
  }

  Future<void> _createPost(Emitter<CreatePostState> emit) async {
    emit(CreatePostState.processing(
        imageFile: state.imageFile,
        postDescription: state.postDescription,
    ));

    try {
      final res = await _dbService.createPost(
        image: state.imageFile!,
        description: state.postDescription,
      );

      switch(res) {
        case Ok<void>():
          emit(CreatePostState.success(
              postDescription: '',
            imageFile: null
          ));
        case Error<void>():
          emit(CreatePostState.failed());
      }

    } catch(e) {
      emit(CreatePostState.failed());
    }
  }

  Future<void> _selectImage(_SelectImage event, Emitter<CreatePostState> emit) async {
    emit(CreatePostState.processing());

    try {
      final res = await _imageService.pickImage(isCamera: event.isCamera);

      emit(CreatePostState.success(imageFile: res));
    } catch(e) {
      emit(CreatePostState.failed());
    }
  }
}

