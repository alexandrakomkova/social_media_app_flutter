part of 'create_post_bloc.dart';

@freezed
sealed class CreatePostState with _$CreatePostState {
  const CreatePostState._();

  const factory CreatePostState.idle({
    @Default('') String postDescription,
    File? imageFile,
  }) = CreatePostState$Idle;

  const factory CreatePostState.processing({
    @Default('') String postDescription,
    File? imageFile,
  }) = CreatePostState$Processing;

  const factory CreatePostState.success({
    @Default('') String postDescription,
    File? imageFile,
  }) = CreatePostState$Success;

  const factory CreatePostState.failed({
    @Default('') String errorMessage,
    @Default('') String postDescription,
    File? imageFile,
  }) = CreatePostState$Failed;
}
