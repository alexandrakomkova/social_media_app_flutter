part of 'post_bloc.dart';

@freezed
abstract class PostEvent with _$PostEvent {
  const PostEvent._();

  const factory PostEvent.getLikesInfo() = _GetLikesInfo;
  const factory PostEvent.addLike() = _AddLike;
  const factory PostEvent.removeLike() = _RemoveLike;
  const factory PostEvent.toggleLike(bool isLiked) = _ToggleLike;
}