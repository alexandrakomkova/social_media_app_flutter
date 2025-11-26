import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState.idle()) {
    on<SearchEvent>((events, emit) async {
      await events.map(
        queryChanged: (event) => _queryChanged(event, emit),
      );
    },
      // transformer: debounced(
      //   duration: const Duration(milliseconds: 500),
      // ),
    );
  }

  _queryChanged(event, Emitter<SearchState> emit) {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }
}
