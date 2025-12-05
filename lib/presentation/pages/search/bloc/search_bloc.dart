import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  SearchBloc({
    required SearchRepository searchRepository,
}) : _searchRepository = searchRepository ,super(const SearchState.idle()) {
    on<SearchEvent>((events, emit) async {
      await events.map(
        queryChanged: (event) => _queryChanged(event, emit),
        searchUsers: (event) => _searchUsers(event, emit),
      );
    }, transformer: restartable()
    );
  }

  Future<void> _queryChanged(_QueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _searchUsers(_SearchUsers event, Emitter<SearchState> emit) async {
    emit(SearchState.processing(searchQuery: state.searchQuery));

    try {
      final res = await _searchRepository.searchUserByUsername(query: state.searchQuery);

      emit(SearchState.success(searchResult: res, searchQuery: state.searchQuery));
    } catch(e) {
      emit(SearchState.failed(searchQuery: state.searchQuery));
    }
  }
}
