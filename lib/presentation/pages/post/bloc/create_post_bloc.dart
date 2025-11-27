import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';
part 'create_post_bloc.freezed.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc() : super(const CreatePostState.idle()) {
    on<CreatePostEvent>((events, emit) async{
      await events.map(
        postDescriptionChanged: (event) => _postDescriptionChanged(event, emit),
        createPost: (_) => _createPost(emit),
      );
    });
  }

  _postDescriptionChanged(
    _PostDescriptionChanged event,
    Emitter<CreatePostState> emit
  ) {
    emit(state.copyWith(postDescription: event.postDescription));
  }

  _createPost(Emitter<CreatePostState> emit) {
    emit(CreatePostState.processing());

    try {
      emit(CreatePostState.success());
    } catch(e) {
      emit(CreatePostState.failed());
    }
  }
}

