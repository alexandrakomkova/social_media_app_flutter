import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/like_repository.dart';

part 'post_bloc.freezed.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final LikeRepository _postRepository;

  PostBloc({
    String? postId,
    required PostEntity postEntity,
    required LikeRepository postRepository,
  }) : _postRepository = postRepository,
       super(PostState.idle(postEntity: postEntity)) {
    on<PostEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_GetLikesInfo):
          await _getLikesInfo(emit);
        case const (_AddLike):
          await _addLike(emit);
        case const (_RemoveLike):
          await _removeLike(emit);
        case const (_ToggleLike):
          await _toggleLike(event as _ToggleLike, emit);
      }
    });
  }

  factory PostBloc.getLikesCount({
    String? postId,
    required PostEntity postEntity,
    required LikeRepository postRepository,
  }) {
    if (postId == null) {
      return PostBloc(postEntity: postEntity, postRepository: postRepository)
        ..add(PostEvent.getLikesInfo());
    } else {
      // get postEntity then get likes info
      return PostBloc(postEntity: postEntity, postRepository: postRepository)
        ..add(PostEvent.getLikesInfo());
    }
  }

  Future<void> _getLikesInfo(Emitter<PostState> emit) async {
    emit(PostState.processing(postEntity: state.postEntity));

    try {
      final res = await _postRepository.getLikesInfo(
        postId: state.postEntity.id.toString(),
      );

      emit(
        PostState.success(
          postEntity: state.postEntity,
          likesCount: res.likesCount,
          isLiked: res.isLiked,
        ),
      );
    } catch (e) {
      emit(PostState.failed(postEntity: state.postEntity));
    }
  }

  Future<void> _addLike(Emitter<PostState> emit) async {
    try {
      await _postRepository.addLike(
        postId: state.postEntity.id.toString(),
        postOwnerId: state.postEntity.userId,
      );

      emit(
        PostState.success(
          postEntity: state.postEntity,
          isLiked: true,
          likesCount: state.likesCount + 1,
        ),
      );
    } catch (e) {
      emit(
        PostState.failed(
          postEntity: state.postEntity,
          isLiked: state.isLiked,
          likesCount: state.likesCount,
        ),
      );
    }
  }

  Future<void> _removeLike(Emitter<PostState> emit) async {
    try {
      await _postRepository.removeLike(postId: state.postEntity.id.toString());
      emit(
        PostState.success(
          postEntity: state.postEntity,
          isLiked: false,
          likesCount: state.likesCount - 1,
        ),
      );
    } catch (e) {
      emit(
        PostState.failed(
          postEntity: state.postEntity,
          isLiked: state.isLiked,
          likesCount: state.likesCount,
        ),
      );
    }
  }

  Future<void> _toggleLike(_ToggleLike event, Emitter<PostState> emit) async {
    if (event.isLiked) {
      await _removeLike(emit);
    } else {
      await _addLike(emit);
    }
  }
}
