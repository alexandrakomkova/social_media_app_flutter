part of 'post_bloc.dart';

@freezed
sealed class PostState with _$PostState {
  const PostState._();

  const factory PostState.idle({
    required PostEntity postEntity,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Idle;

  const factory PostState.processing({
    required PostEntity postEntity,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Processing;

  const factory PostState.success({
    required PostEntity postEntity,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Success;

  const factory PostState.failed({
    required PostEntity postEntity,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Failed;
}
