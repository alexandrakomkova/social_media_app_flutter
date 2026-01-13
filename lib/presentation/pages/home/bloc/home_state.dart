part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.idle({required Pagination<PostEntity> pagination}) =
      HomeState$Idle;

  const factory HomeState.processing({
    required Pagination<PostEntity> pagination,
  }) = HomeState$Processing;

  const factory HomeState.success({
    required Pagination<PostEntity> pagination,
  }) = HomeState$Success;

  const factory HomeState.failed({
    required Pagination<PostEntity> pagination,
    @Default('') String errorMessage,
  }) = HomeState$Failed;
}
