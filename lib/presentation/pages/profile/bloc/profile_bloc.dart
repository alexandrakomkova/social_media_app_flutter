import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/presentation/model/pagination.dart';
import 'package:social_media_app/utils/firebase_service.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

final _log = Logger('ProfileBloc');

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  }) : _authRepository = authRepository,
       _profileRepository = profileRepository,
       super(
         ProfileState.idle(
           pagination: Pagination<PostEntity>.empty(),
           followersPagination: Pagination<UserEntity>.empty(),
           followingsPagination: Pagination<UserEntity>.empty(),
         ),
       ) {
    on<ProfileEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_GetUserProfile):
          await _getUserProfile(event as _GetUserProfile, emit);
        case const (_FollowUser):
          await _followUser(event as _FollowUser, emit);
        case const (_UnfollowUser):
          await _unfollowUser(event as _UnfollowUser, emit);
        case const (_SignOut):
          await _signOut(emit);
        case const (_GetUserPostsNext):
          await _getUserPostsNext(event as _GetUserPostsNext, emit);
        case const (_GetFollowers):
          await _getFollowers(event as _GetFollowers, emit);
        case const (_GetFollowings):
          await _getFollowings(event as _GetFollowings, emit);
      }
    }, transformer: droppable());
  }

  factory ProfileBloc.getUserProfile({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required String id,
  }) => ProfileBloc(
    authRepository: authRepository,
    profileRepository: profileRepository,
  )..add(ProfileEvent.getUserProfile(userId: id));

  Future<void> _signOut(Emitter<ProfileState> emit) async {
    emit(
      ProfileState.processing(
        pagination: state.pagination,
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
      ),
    );

    try {
      final res = await _authRepository.signOut();

      res.fold(
        (onError) {
          final String errorMessage = onError.error is FirebaseAuthException
              ? (onError.error as FirebaseAuthException).message ?? ''
              : 'An unexpected error occurred';
          emit(
            ProfileState.failed(
              errorMessage: errorMessage,
              pagination: state.pagination,
              followersPagination: state.followersPagination,
              followingsPagination: state.followingsPagination,
            ),
          );
        },
        (onOk) {
          emit(
            ProfileState.success(
              pagination: state.pagination,
              followersPagination: state.followersPagination,
              followingsPagination: state.followingsPagination,
            ),
          );
        },
      );
    } catch (e) {
      final String errorMessage = e is FirebaseAuthException
          ? e.message ?? ''
          : 'An unexpected error occurred';
      emit(
        ProfileState.failed(
          errorMessage: errorMessage,
          pagination: state.pagination,
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination,
        ),
      );
    }
  }

  Future<void> _getUserPostsNext(
    _GetUserPostsNext event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileState.processing(
        user: state.user,
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
        isFollowed: state.isFollowed,
        postsCount: state.postsCount,
        followingsCount: state.followingsCount,
        followersCount: state.followersCount,
        pagination: state.pagination,
      ),
    );

    try {
      final res = await _profileRepository.getUserPostsNext(
        userId: event.userId,
        lastDoc: state.pagination.lastDoc,
      );

      state.pagination.addItemsToList(res.list);

      emit(
        ProfileState.success(
          user: state.user,
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination,
          isFollowed: state.isFollowed,
          postsCount: state.postsCount,
          followingsCount: state.followingsCount,
          followersCount: state.followersCount,
          pagination: state.pagination.copyWith(
            hasMoreToLoad: res.hasMoreToLoad,
            lastDoc: res.lastDoc,
          ),
        ),
      );

      _log.info(
        'state: ${state.pagination.hasMoreToLoad} ${state.pagination.lastDoc.toString()}',
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          errorMessage: e.toString(),
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination,
          pagination: state.pagination.copyWith(list: [], hasMoreToLoad: false),
        ),
      );
    }
  }

  Future<void> _getUserProfile(
    _GetUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileState.processing(
        pagination: state.pagination,
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
      ),
    );

    try {
      final postsRes = await _profileRepository.getUserPostsNext(
        userId: event.userId,
      );

      final postsCount = await _profileRepository.getPostsCount(
        userId: event.userId,
      );

      final followersCount = await _profileRepository.getFollowersCount(
        userId: event.userId,
      );

      final followingsCount = await _profileRepository.getFollowingsCount(
        userId: event.userId,
      );

      final user = await _profileRepository.getUserInfo(userId: event.userId);

      final PaginationResponse<UserEntity> followersRes =
          await _profileRepository.getFollowers(
            userId: event.userId,
            lastDoc: state.followersPagination.lastDoc,
          );

      final PaginationResponse<UserEntity> followingsRes =
          await _profileRepository.getFollowings(
            userId: event.userId,
            lastDoc: state.followingsPagination.lastDoc,
          );

      final bool isFollowed = await _profileRepository.isFollowedByCurrentUser(
        profileOwnerUserId: event.userId,
      );

      emit(
        ProfileState.success(
          postsCount: postsCount,
          followersCount: followersCount,
          followingsCount: followingsCount,
          user: user,
          followersPagination: state.followersPagination.copyWith(
            list: followersRes.list,
            lastDoc: followersRes.lastDoc,
          ),
          followingsPagination: state.followingsPagination.copyWith(
            list: followingsRes.list,
            lastDoc: followingsRes.lastDoc,
          ),
          isFollowed: isFollowed,
          pagination: state.pagination.copyWith(
            list: postsRes.list,
            lastDoc: postsRes.lastDoc,
          ),
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          pagination: state.pagination,
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _followUser(
    _FollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.followUser(
        userId: FirebaseService.currentUserId,
        userIdToFollow: event.userIdToFollow,
      );
      final PaginationResponse<UserEntity> followersRes =
          await _profileRepository.getFollowers(userId: event.userIdToFollow);

      emit(
        ProfileState.success(
          user: state.user,
          followersPagination: state.followersPagination.copyWith(
            list: followersRes.list,
            lastDoc: followersRes.lastDoc,
          ),
          followingsPagination: state.followingsPagination,
          isFollowed: !state.isFollowed,
          postsCount: state.postsCount,
          pagination: state.pagination,
          followersCount: state.followersCount,
          followingsCount: state.followingsCount,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination,
          pagination: state.pagination,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _unfollowUser(
    _UnfollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.unfollowUser(
        userId: FirebaseService.currentUserId,
        userIdToUnfollow: event.userIdToUnfollow,
      );
      final PaginationResponse<UserEntity> followersRes =
          await _profileRepository.getFollowers(userId: event.userIdToUnfollow);

      emit(
        ProfileState.success(
          user: state.user,
          followersPagination: state.followersPagination.copyWith(
            list: followersRes.list,
            lastDoc: followersRes.lastDoc,
          ),
          followingsPagination: state.followingsPagination,
          isFollowed: !state.isFollowed,
          postsCount: state.postsCount,
          followersCount: state.followersCount,
          followingsCount: state.followingsCount,
          pagination: state.pagination,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          followingsPagination: state.followingsPagination,
          followersPagination: state.followersPagination,
          pagination: state.pagination,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _getFollowers(
    _GetFollowers event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileState.processing(
        user: state.user,
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
        isFollowed: state.isFollowed,
        postsCount: state.postsCount,
        followersCount: state.followersCount,
        followingsCount: state.followingsCount,
        pagination: state.pagination,
      ),
    );

    try {
      final res = await _profileRepository.getFollowers(
        userId: event.userId,
        lastDoc: state.followersPagination.lastDoc,
      );

      state.followersPagination.addItemsToList(res.list);

      emit(
        ProfileState.success(
          user: state.user,
          followersPagination: state.followersPagination.copyWith(
            hasMoreToLoad: res.hasMoreToLoad,
            lastDoc: res.lastDoc,
          ),
          followingsPagination: state.followingsPagination,
          isFollowed: state.isFollowed,
          postsCount: state.postsCount,
          pagination: state.pagination,
          followersCount: state.followersCount,
          followingsCount: state.followingsCount,
        ),
      );

      _log.info(
        'state: ${state.followersPagination.hasMoreToLoad} ${state.followersPagination.lastDoc.toString()}',
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          errorMessage: e.toString(),
          followingsPagination: state.followingsPagination,
          followersPagination: state.followersPagination.copyWith(
            list: [],
            hasMoreToLoad: false,
          ),
          pagination: state.pagination,
        ),
      );
    }
  }

  Future<void> _getFollowings(
    _GetFollowings event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileState.processing(
        user: state.user,
        followersPagination: state.followersPagination,
        followingsPagination: state.followingsPagination,
        isFollowed: state.isFollowed,
        postsCount: state.postsCount,
        followersCount: state.followersCount,
        followingsCount: state.followingsCount,
        pagination: state.pagination,
      ),
    );

    try {
      final res = await _profileRepository.getFollowings(
        userId: event.userId,
        lastDoc: state.followingsPagination.lastDoc,
      );

      state.followingsPagination.addItemsToList(res.list);

      emit(
        ProfileState.success(
          user: state.user,
          followersPagination: state.followersPagination,
          followingsPagination: state.followingsPagination.copyWith(
            hasMoreToLoad: res.hasMoreToLoad,
            lastDoc: res.lastDoc,
          ),
          isFollowed: state.isFollowed,
          postsCount: state.postsCount,
          pagination: state.pagination,
          followersCount: state.followersCount,
          followingsCount: state.followingsCount,
        ),
      );

      _log.info(
        'state: ${state.followingsPagination.hasMoreToLoad} ${state.followingsPagination.lastDoc.toString()}',
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          errorMessage: e.toString(),
          followingsPagination: state.followingsPagination.copyWith(
            list: [],
            hasMoreToLoad: false,
          ),
          followersPagination: state.followersPagination,
          pagination: state.pagination,
        ),
      );
    }
  }
}
