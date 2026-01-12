part of 'search_bloc.dart';

@freezed
sealed class SearchState with _$SearchState {
  const SearchState._();

  const factory SearchState.idle({
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Idle;

  const factory SearchState.processing({
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Proccessing;

  const factory SearchState.success({
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
  }) = SearchState$Success;

  const factory SearchState.failed({
    @Default('') String searchQuery,
    @Default([]) List<UserEntity> searchResult,
    @Default('') String errorMessage,
  }) = SearchState$Failed;
}
