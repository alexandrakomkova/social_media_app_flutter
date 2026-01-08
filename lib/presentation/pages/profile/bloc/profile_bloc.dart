import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
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
       super(const ProfileState.idle()) {
    on<ProfileEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (_GetUserInfo):
          await _getUserInfo(event as _GetUserInfo, emit);
        case const (_GetUserPosts):
          await _getUserPosts(event as _GetUserPosts, emit);
        case const (_GetUserProfile):
          await _getUserProfile(event as _GetUserProfile, emit);
        case const (_FollowUser):
          await _followUser(event as _FollowUser, emit);
        case const (_UnfollowUser):
          await _unfollowUser(event as _UnfollowUser, emit);
        case const (_SignOut):
          await _signOut(emit);
      }
    }, transformer: sequential());
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
    emit(ProfileState.processing());

    try {
      final res = await _authRepository.signOut();

      res.fold(
        (onError) {
          final String errorMessage = onError.error is FirebaseAuthException
              ? (onError.error as FirebaseAuthException).message ?? ''
              : 'An unexpected error occurred';
          emit(ProfileState.failed(errorMessage: errorMessage));
        },
        (onOk) {
          emit(ProfileState.success());
        },
      );
    } catch (e) {
      final String errorMessage = e is FirebaseAuthException
          ? e.message ?? ''
          : 'An unexpected error occurred';
      emit(ProfileState.failed(errorMessage: errorMessage));
    }
  }

  Future<void> _getUserInfo(
    _GetUserInfo event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileState.processing());

    try {
      final user = await _profileRepository.getUserInfo(userId: event.userId);

      emit(ProfileState.success(user: user));
    } catch (e) {
      _log.warning(e.toString());
      emit(ProfileState.failed());
    }
  }

  Future<void> _getUserPosts(
    _GetUserPosts event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileState.processing());

    try {
      final res = await _profileRepository.getUserPosts(userId: event.userId);

      emit(ProfileState.success(posts: res));
    } catch (e) {
      _log.warning(e.toString());
      emit(ProfileState.failed(posts: []));
    }
  }

  Future<void> _getUserProfile(
    _GetUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileState.processing());

    try {
      final List<PostEntity> posts = await _profileRepository.getUserPosts(
        userId: event.userId,
      );
      final user = await _profileRepository.getUserInfo(userId: event.userId);
      final List<UserEntity> followers = await _profileRepository.getFollowers(
        userId: event.userId,
      );
      final List<UserEntity> followings = await _profileRepository
          .getFollowings(userId: event.userId);

      final bool isFollowed = await _profileRepository.isFollowedByCurrentUser(
        profileOwnerUserId: event.userId,
      );

      emit(
        ProfileState.success(
          posts: posts,
          user: user,
          followers: followers,
          followings: followings,
          isFollowed: isFollowed,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(ProfileState.failed());
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
      final List<UserEntity> followers = await _profileRepository.getFollowers(
        userId: event.userIdToFollow,
      );

      emit(
        ProfileState.success(
          posts: state.posts,
          user: state.user,
          followers: followers,
          followings: state.followings,
          isFollowed: !state.isFollowed,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          posts: state.posts,
          user: state.user,
          followers: state.followers,
          followings: state.followings,
          isFollowed: state.isFollowed,
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
      final List<UserEntity> followers = await _profileRepository.getFollowers(
        userId: event.userIdToUnfollow,
      );

      emit(
        ProfileState.success(
          posts: state.posts,
          user: state.user,
          followers: followers,
          followings: state.followings,
          isFollowed: !state.isFollowed,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        ProfileState.failed(
          posts: state.posts,
          user: state.user,
          followers: state.followers,
          followings: state.followings,
          isFollowed: state.isFollowed,
        ),
      );
    }
  }
}
