import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({
    required HomeRepository homeRepository
  }) : _homeRepository = homeRepository,
        super(const HomeState.idle()) {
    on<HomeEvent>((events, emit) async {
      await events.map(
          getNewPosts: (_) => _getNewPosts(emit),
      );
    });
  }

  Future<void> _getNewPosts(Emitter<HomeState> emit) async {
    emit(HomeState.processing());

    try {
      final posts = await _homeRepository.getNewPosts();

      emit(HomeState.success(
        posts: posts,
      ));
    } catch(e) {
      emit(HomeState.failed());
    }
  }
}
