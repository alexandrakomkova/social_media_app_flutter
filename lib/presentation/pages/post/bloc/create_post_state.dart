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
  }) = CreatePostState$Idle;

  const factory CreatePostState.processing({
    @Default(CreatePostStatus.processing) CreatePostStatus status,
    @Default('') String postDescription,
  }) = CreatePostState$Processing;

  const factory CreatePostState.success({
    @Default(CreatePostStatus.success) CreatePostStatus status,
    @Default('') String postDescription,
  }) = CreatePostState$Success;

  const factory CreatePostState.failed({
    @Default(CreatePostStatus.failed) CreatePostStatus status,
    @Default('') String postDescription,
  }) = CreatePostState$Failed;
}
