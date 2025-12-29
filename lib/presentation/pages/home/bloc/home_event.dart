part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const HomeEvent._();

  const factory HomeEvent.getNewPosts() = _GetNewPosts;
}
