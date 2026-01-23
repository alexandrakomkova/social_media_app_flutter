part of 'comments_bloc.dart';

@freezed
sealed class CommentsEvent with _$CommentsEvent {
  const CommentsEvent._();

  const factory CommentsEvent.getCommentsInfo() = _GetCommentsInfo;

  const factory CommentsEvent.getCommentsNext() = _GetCommentsNext;

  const factory CommentsEvent.getComments() = _GetComments;

  const factory CommentsEvent.addComment() = _AddComment;

  const factory CommentsEvent.commentTextChanged(String commentText) =
      _CommentTextChanged;
}
