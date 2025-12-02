part of 'post_bloc.dart';

enum PostStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class PostState with _$PostState{
  const PostState._();

  const factory PostState.idle({
    @Default(PostStatus.idle) PostStatus status,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Idle;

  const factory PostState.processing({
    @Default(PostStatus.processing) PostStatus status,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Processing;

  const factory PostState.success({
    @Default(PostStatus.success) PostStatus status,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Success;

  const factory PostState.failed({
    @Default(PostStatus.failed) PostStatus status,
    @Default(0) int likesCount,
    @Default(false) isLiked,
  }) = PostState$Failed;
}