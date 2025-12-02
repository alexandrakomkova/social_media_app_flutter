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
}
