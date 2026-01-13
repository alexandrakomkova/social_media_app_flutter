part of 'create_post_bloc.dart';

@freezed
sealed class CreatePostEvent with _$CreatePostEvent {
  const CreatePostEvent._();

  const factory CreatePostEvent.postDescriptionChanged(String postDescription) =
      _PostDescriptionChanged;

  const factory CreatePostEvent.selectImage(bool isCamera) = _SelectImage;

  const factory CreatePostEvent.createPost() = _CreatePost;
}
