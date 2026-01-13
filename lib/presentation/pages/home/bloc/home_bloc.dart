import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/home_repository.dart';
import 'package:social_media_app/presentation/model/pagination.dart';
import 'package:social_media_app/utils/firebase_service.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeState.idle(pagination: Pagination<PostEntity>.empty())) {
    on<HomeEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_GetNewPosts):
          await _getNewPosts(emit);
      }
    }, transformer: droppable());
  }

  factory HomeBloc.getNewPosts({required HomeRepository homeRepository}) =>
      HomeBloc(homeRepository: homeRepository)..add(HomeEvent.getNewPosts());

  Future<void> _getNewPosts(Emitter<HomeState> emit) async {
    emit(HomeState.processing(pagination: state.pagination));

    try {
      final res = await _homeRepository.getNewPosts(
        userId: FirebaseService.currentUserId,
        lastDoc: state.pagination.lastDoc,
      );

      state.pagination.addItemsToList(res.list);

      emit(
        HomeState.success(
          pagination: state.pagination.copyWith(
            lastDoc: res.lastDoc,
            hasMoreToLoad: res.hasMoreToLoad,
          ),
        ),
      );
    } catch (e) {
      emit(
        HomeState.failed(
          pagination: state.pagination.copyWith(hasMoreToLoad: false),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
