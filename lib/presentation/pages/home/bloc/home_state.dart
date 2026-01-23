part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.idle() = HomeState$Idle;

  const factory HomeState.processing() = HomeState$Processing;

  const factory HomeState.success({
    required Pagination<PostEntity> pagination,
  }) = HomeState$Success;

  const factory HomeState.failed({@Default('') String errorMessage}) =
      HomeState$Failed;
}
