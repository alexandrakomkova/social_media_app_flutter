import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';
part 'post_bloc.freezed.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc({
    required PostEntity postEntity,
    required PostRepository postRepository,
  }) : _postRepository = postRepository,
        super(PostState.idle(postEntity: postEntity)) {
    on<PostEvent>((events, emit) async {
      await events.map(
        getLikesInfo: (_) => _getLikesInfo(emit),
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
      )..add(PostEvent.getLikesInfo());

  Future<void> _getLikesInfo(Emitter<PostState> emit) async {
    emit(PostState.processing(
      postEntity: state.postEntity
    ));

    try {
      final res = await _postRepository.getLikesInfo(postId: state.postEntity.id.toString());

      emit(PostState.success(
          postEntity: state.postEntity,
        likesCount: res['likesCount'] ?? 0,
        isLiked: res['isLiked'] == 1 ? true : false
      ));
    } catch(e) {
      emit(PostState.failed(
          postEntity: state.postEntity,
      ));
    }
  }

  Future<void> _addLike(Emitter<PostState> emit) async{
    try {
      await _postRepository.addLike(postId: state.postEntity.id.toString());

      emit(PostState.success(
          postEntity: state.postEntity,
        isLiked: true,
          likesCount: state.likesCount + 1
      ));
    } catch(e) {
      emit(PostState.failed(
          postEntity: state.postEntity,
        isLiked: state.isLiked,
          likesCount: state.likesCount
      ));
    }
  }

  Future<void> _removeLike(Emitter<PostState> emit) async {
    try {
      await _postRepository.removeLike(postId: state.postEntity.id.toString());
      emit(PostState.success(
          postEntity: state.postEntity,
          isLiked: false,
          likesCount: state.likesCount - 1
      ));
    } catch (e) {
      emit(PostState.failed(
          postEntity: state.postEntity,
          isLiked: state.isLiked,
          likesCount: state.likesCount
      ));
    }
  }

  Future<void> _toggleLike(_ToggleLike event, Emitter<PostState> emit) async {
    if(event.isLiked) {
      await _removeLike(emit);
    } else {
      await _addLike(emit);
    }
  }
}
