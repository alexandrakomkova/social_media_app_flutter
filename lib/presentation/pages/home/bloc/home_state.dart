part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.idle({@Default([]) List<PostEntity> posts}) =
      HomeState$Idle;

  const factory HomeState.processing({@Default([]) List<PostEntity> posts}) =
      HomeState$Processing;

  const factory HomeState.success({@Default([]) List<PostEntity> posts}) =
      HomeState$Success;

  const factory HomeState.failed({
    @Default([]) List<PostEntity> posts,
    @Default('') String errorMessage,
  }) = HomeState$Failed;
}
