import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';
import 'package:social_media_app/utils/firebase_service.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const HomeState.idle()) {
    on<HomeEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_GetNewPosts):
          await _getNewPosts(emit);
      }
    });
  }

  factory HomeBloc.getNewPosts({required HomeRepository homeRepository}) =>
      HomeBloc(homeRepository: homeRepository)..add(HomeEvent.getNewPosts());

  Future<void> _getNewPosts(Emitter<HomeState> emit) async {
    emit(HomeState.processing());

    try {
      final posts = await _homeRepository.getNewPosts(
        userId: FirebaseService.currentUserId,
      );

      emit(HomeState.success(posts: posts));
    } catch (e) {
      emit(HomeState.failed(errorMessage: e.toString()));
    }
  }
}
