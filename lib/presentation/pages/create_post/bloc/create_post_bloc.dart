import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/repository/db_service.dart';
import 'package:social_media_app/domain/repository/image_service.dart';
import 'package:social_media_app/utils/result.dart';

part 'create_post_bloc.freezed.dart';
part 'create_post_event.dart';
part 'create_post_state.dart';

final _log = Logger('CreatePostBloc');

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final ImageService _imageService;
  final DbService _dbService;

  CreatePostBloc({
    required ImageService imageService,
    required DbService dbService,
  }) : _imageService = imageService,
       _dbService = dbService,
       super(const CreatePostState.idle()) {
    on<CreatePostEvent>((event, emit) async {
      switch (event) {
        case _PostDescriptionChanged():
          await _postDescriptionChanged(event, emit);
        case _SelectImage():
          await _selectImage(event, emit);
        case _CreatePost():
          await _createPost(emit);
      }
    });
  }

  Future<void> _postDescriptionChanged(
    _PostDescriptionChanged event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(state.copyWith(postDescription: event.postDescription));
  }

  Future<void> _createPost(Emitter<CreatePostState> emit) async {
    emit(
      CreatePostState.processing(
        imageFile: state.imageFile,
        postDescription: state.postDescription.trim(),
      ),
    );

    try {
      final res = await _dbService.createPost(
        image: state.imageFile,
        description: state.postDescription,
      );

      switch (res) {
        case Ok<void>():
          emit(CreatePostState.success());
        case Failure<void>():
          _log.warning(res.error.toString());
          emit(
            CreatePostState.failed(
              errorMessage: res.error.toString(),
              postDescription: state.postDescription,
              imageFile: state.imageFile,
            ),
          );
      }
    } catch (e) {
      _log.warning(e.toString());
      emit(
        CreatePostState.failed(
          errorMessage: e.toString(),
          postDescription: state.postDescription,
          imageFile: state.imageFile,
        ),
      );
    }
  }

  Future<void> _selectImage(
    _SelectImage event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostState.processing());

    try {
      final res = await _imageService.pickImage(isCamera: event.isCamera);

      emit(
        CreatePostState.success(
          imageFile: res,
          postDescription: state.postDescription,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        CreatePostState.failed(
          errorMessage: e.toString(),
          postDescription: state.postDescription,
          imageFile: state.imageFile,
        ),
      );
    }
  }
}
