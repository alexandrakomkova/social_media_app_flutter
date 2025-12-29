part of 'comments_bloc.dart';

enum CommentsStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class CommentsState with _$CommentsState {
  const CommentsState._();

  const factory CommentsState.idle({
    @Default(CommentsStatus.idle) CommentsStatus status,
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Idle;

  const factory CommentsState.processing({
    @Default(CommentsStatus.processing) CommentsStatus status,
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Processing;

  const factory CommentsState.success({
    @Default(CommentsStatus.success) CommentsStatus status,
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Success;

  const factory CommentsState.failed({
    @Default(CommentsStatus.failed) CommentsStatus status,
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Failed;
}