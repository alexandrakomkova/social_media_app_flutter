part of 'home_bloc.dart';

enum HomeStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.idle({
    @Default(HomeStatus.idle) HomeStatus status,
    @Default([]) List<PostEntity> posts,
  }) = HomeState$Idle;

  const factory HomeState.processing({
    @Default(HomeStatus.processing) HomeStatus status,
    @Default([]) List<PostEntity> posts,
  }) = HomeState$Processing;

  const factory HomeState.success({
    @Default(HomeStatus.success) HomeStatus status,
    @Default([]) List<PostEntity> posts,
  }) = HomeState$Success;

  const factory HomeState.failed({
    @Default(HomeStatus.failed) HomeStatus status,
    @Default([]) List<PostEntity> posts,
    @Default('') String errorMessage,
  }) = HomeState$Failed;
}
