part of 'create_post_bloc.dart';

@freezed
abstract class CreatePostEvent with _$CreatePostEvent {
  const CreatePostEvent._();

  const factory CreatePostEvent.postDescriptionChanged(String postDescription) = _PostDescriptionChanged;
  const factory CreatePostEvent.createPost() = _CreatePost;
}
