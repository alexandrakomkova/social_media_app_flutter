import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';
part 'post_bloc.freezed.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostEntity _postEntity;
  final PostRepository _postRepository;

  PostBloc({
    required PostEntity postEntity,
    required PostRepository postRepository,
  }) : _postEntity = postEntity,
      _postRepository = postRepository,
        super(const PostState.idle()) {
    on<PostEvent>((events, emit) async {
      await events.map(
        getLikesCount: (_) => _getLikesCount(emit),
        addLike: (_) => _addLike(emit),
        removeLike: (_) => _removeLike(emit),
        toggleLike: (event) => _toggleLike(event, emit),
      );
    });
  }

  factory PostBloc.getLikesCount({
    required PostEntity postEntity,
    required PostRepository postRepository,
  }) =>
      PostBloc(
        postEntity: postEntity,
        postRepository: postRepository
      )..add(PostEvent.getLikesCount());

  _getLikesCount(Emitter<PostState> emit) async {
    emit(PostState.processing());

    try {
      final res = await _postRepository.getLikesCount(_postEntity.id.toString());

      emit(PostState.success(
        likesCount: res
      ));
    } catch(e) {
      emit(PostState.failed());
    }
  }

  _addLike(Emitter<PostState> emit) async{
    try {
      await _postRepository.addLike(_postEntity.id.toString());

      emit(PostState.success(
        isLiked: true,
          likesCount: state.likesCount + 1
      ));
    } catch(e) {
      emit(PostState.failed(
        isLiked: state.isLiked,
          likesCount: state.likesCount
      ));
    }
  }

  _removeLike(Emitter<PostState> emit) {

  }

  _toggleLike(_ToggleLike event, Emitter<PostState> emit) {
    if(event.isLiked) {
      _removeLike(emit);
    } else {
      _addLike(emit);
    }
  }
}
