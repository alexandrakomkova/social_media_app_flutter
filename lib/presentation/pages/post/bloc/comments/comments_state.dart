part of 'comments_bloc.dart';

@freezed
sealed class CommentsState with _$CommentsState {
  const CommentsState._();

  const factory CommentsState.idle({
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
    @Default(0) int commentsCount,
    required Pagination<CommentEntity> pagination,
  }) = CommentsState$Idle;

  const factory CommentsState.processing({
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
    @Default(0) int commentsCount,
    required Pagination<CommentEntity> pagination,
  }) = CommentsState$Processing;

  const factory CommentsState.success({
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
    @Default(0) int commentsCount,
    required Pagination<CommentEntity> pagination,
  }) = CommentsState$Success;

  const factory CommentsState.failed({
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
    @Default(0) int commentsCount,
    required Pagination<CommentEntity> pagination,
  }) = CommentsState$Failed;
}
