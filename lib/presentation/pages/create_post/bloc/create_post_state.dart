part of 'create_post_bloc.dart';

enum CreatePostStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class CreatePostState with _$CreatePostState {
  const CreatePostState._();

  const factory CreatePostState.idle({
    @Default(CreatePostStatus.idle) CreatePostStatus status,
    @Default('') String postDescription,
    @Default(null) File? imageFile,
  }) = CreatePostState$Idle;

  const factory CreatePostState.processing({
    @Default(CreatePostStatus.processing) CreatePostStatus status,
    @Default('') String postDescription,
    @Default(null) File? imageFile,
  }) = CreatePostState$Processing;

  const factory CreatePostState.success({
    @Default(CreatePostStatus.success) CreatePostStatus status,
    @Default('') String postDescription,
    @Default(null) File? imageFile,
  }) = CreatePostState$Success;

  const factory CreatePostState.failed({
    @Default(CreatePostStatus.failed) CreatePostStatus status,
    @Default('') String postDescription,
    @Default(null) File? imageFile,
  }) = CreatePostState$Failed;
}
