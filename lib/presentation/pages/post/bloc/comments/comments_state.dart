part of 'comments_bloc.dart';

@freezed
sealed class CommentsState with _$CommentsState {
  const CommentsState._();

  const factory CommentsState.idle({
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Idle;

  const factory CommentsState.processing({
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Processing;

  const factory CommentsState.success({
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Success;

  const factory CommentsState.failed({
    @Default([]) List<CommentEntity> comments,
    @Default('') String commentText,
    @Default('') String postId,
    @Default('') String postOwnerId,
  }) = CommentsState$Failed;
}
