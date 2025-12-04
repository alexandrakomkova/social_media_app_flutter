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
    @Default([]) posts,
  }) = HomeState$Idle;

  const factory HomeState.processing({
    @Default(HomeStatus.processing) HomeStatus status,
    @Default([]) posts,
  }) = HomeState$Processing;

  const factory HomeState.success({
    @Default(HomeStatus.success) HomeStatus status,
    @Default([]) posts,
  }) = HomeState$Success;

  const factory HomeState.failed({
    @Default(HomeStatus.failed) HomeStatus status,
    @Default([]) posts,
  }) = HomeState$Failed;
}
