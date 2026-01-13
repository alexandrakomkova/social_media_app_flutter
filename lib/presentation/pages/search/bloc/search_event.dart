part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const SearchEvent._();

  const factory SearchEvent.queryChanged(String query) = _QueryChanged;

  const factory SearchEvent.searchUsers(String query) = _SearchUsers;
}
