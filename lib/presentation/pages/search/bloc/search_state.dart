part of 'search_bloc.dart';

enum SearchStatus {
  idle,
  processing,
  success,
  failed,
}

@freezed
sealed class SearchState with _$SearchState {
  const SearchState._();

  const factory SearchState.idle({
    @Default(SearchStatus.idle) SearchStatus status,
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Idle;

  const factory SearchState.processing({
    @Default(SearchStatus.processing) SearchStatus status,
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Proccessing;

  const factory SearchState.success({
    @Default(SearchStatus.success) SearchStatus status,
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Success;

  const factory SearchState.failed({
    @Default(SearchStatus.failed) SearchStatus status,
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Failed;
}