import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/follow_repository.dart';
import 'package:social_media_app/presentation/model/pagination.dart';

part 'follow_bloc.freezed.dart';
part 'follow_event.dart';
part 'follow_state.dart';

final _log = Logger('FollowBloc');

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowRepository _followRepository;

  FollowBloc({required FollowRepository followRepository})
    : _followRepository = followRepository,
      super(
        FollowState.idle(
          followersPagination: Pagination<UserEntity>.empty(),
          followingsPagination: Pagination<UserEntity>.empty(),
        ),
      ) {
    on<FollowEvent>((event, emit) async {
      switch (event) {
        case _GetFollowers():
          await _getFollowers(event, emit);
        case _GetFollowings():
          await _getFollowings(event, emit);
      }
    }, transformer: droppable());
  }

  Future<void> _getFollowers(
    _GetFollowers event,
    Emitter<FollowState> emit,
  ) async {
    emit(
      FollowState.processing(
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
      ),
    );

    try {
      final res = await _followRepository.getFollowers(
        userId: event.userId,
        lastDoc: state.followersPagination.lastDoc,
      );

      state.followersPagination.addItemsToList(res.list);

      emit(
        FollowState.success(
          followersPagination: state.followersPagination.copyWith(
            hasMoreToLoad: res.hasMoreToLoad,
            lastDoc: res.lastDoc,
          ),
          followingsPagination: state.followingsPagination,
        ),
      );

      _log.info(
        'state: ${state.followersPagination.hasMoreToLoad} ${state.followersPagination.lastDoc.toString()}',
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        FollowState.failed(
          errorMessage: e.toString(),
          followingsPagination: state.followingsPagination,
          followersPagination: state.followersPagination.copyWith(
            list: [],
            hasMoreToLoad: false,
          ),
        ),
      );
    }
  }

  Future<void> _getFollowings(
    _GetFollowings event,
    Emitter<FollowState> emit,
  ) async {
    emit(
      FollowState.processing(
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
      ),
    );

    try {
      final res = await _followRepository.getFollowings(
        userId: event.userId,
        lastDoc: state.followingsPagination.lastDoc,
      );

      state.followingsPagination.addItemsToList(res.list);

      emit(
        FollowState.success(
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination.copyWith(
            hasMoreToLoad: res.hasMoreToLoad,
            lastDoc: res.lastDoc,
          ),
        ),
      );

      _log.info(
        'state: ${state.followingsPagination.hasMoreToLoad} ${state.followingsPagination.lastDoc.toString()}',
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        FollowState.failed(
          errorMessage: e.toString(),
          followingsPagination: state.followingsPagination.copyWith(
            list: [],
            hasMoreToLoad: false,
          ),
          followersPagination: state.followersPagination,
        ),
      );
    }
  }
}
