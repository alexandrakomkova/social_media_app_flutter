import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/domain/repository/profile_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/pages/settings/settings_page.dart';
import 'package:social_media_app/presentation/widget/bottom_sheet_followers_followings_list.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/custom_loader.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';
import 'package:social_media_app/presentation/widget/profile_info_card.dart';
import 'package:social_media_app/presentation/widget/profile_post_tile.dart';
import 'package:social_media_app/utils/firebase_service.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc.getUserProfile(
        authRepository: context.read<AuthRepository>(),
        profileRepository: context.read<ProfileRepository>(),
        id: userId,
      ),
      child: _ProfileView(userId: userId),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final String userId;

  const _ProfileView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileState$Failed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Text(
                state.user?.username ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            },
          ),
          actions: userId == FirebaseService.currentUserId
              ? [
                  IconButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => SettingsPage()));
                    },
                    icon: Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () {
                      _showLogoutAlertDialog(context);
                    },
                    icon: Icon(Icons.logout),
                  ),
                ]
              : null,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (profileContext, state) {
            final l10n = context.l10n;

            return switch (state) {
              ProfileState$Idle() => SizedBox(),
              ProfileState$Processing() => CustomLoader(),
              ProfileState$Failed() => Center(
                child: Text(l10n.errorOccurredText(state.errorMessage)),
              ),
              ProfileState$Success() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _profileHeader(context: context, state: state),
                    _userBio(context: context, bio: state.user?.bio ?? ''),

                    SizedBox(height: 10.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            l10n.allPostsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0),
                    _postsGrid(context, state.posts),
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }

  void _showLogoutAlertDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        dialogTitle: l10n.logoutDialogTitle,
        dialogContent: l10n.logoutDialogText,
        rightButtonTitle: l10n.continueButton,
        onRightPressed: () {
          context.read<ProfileBloc>().add(ProfileEvent.signOut());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => SignInPage()),
            (route) => false,
          );
        },
        leftButtonTitle: l10n.cancelButton,
        onLeftPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _profileHeader({
    required BuildContext context,
    required ProfileState state,
  }) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileAvatar(
              radius: 50.0,
              username: state.user?.username ?? '',
              photoUrl: state.user?.photoUrl ?? '',
            ),
          ],
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _profileInfo(context: context),
              SizedBox(height: 10.0),

              if (userId != FirebaseService.currentUserId)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            state.isFollowed
                                ? context.read<ProfileBloc>().add(
                                    ProfileEvent.unfollowUser(
                                      userIdToUnfollow: userId,
                                    ),
                                  )
                                : context.read<ProfileBloc>().add(
                                    ProfileEvent.followUser(
                                      userIdToFollow: userId,
                                    ),
                                  );
                          },
                          child: Text(
                            state.isFollowed
                                ? l10n.unfollowButton
                                : l10n.followButton,
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userBio({required BuildContext context, required String bio}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              bio,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileInfo({required BuildContext context}) {
    final l10n = context.l10n;
    final state = context.watch<ProfileBloc>().state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileInfoCard(
          value: state.posts.length.toString(),
          valueLabel: l10n.profileInfoCardPostsCount,
        ),
        ProfileInfoCard(
          value: state.followers.length.toString(),
          valueLabel: l10n.profileInfoCardFollowersCount,
          onTap: () {
            showBottomSheetCreationVariants(
              context: context,
              bottomSheetTitle: l10n.bottomSheetFollowersTitle,
              users: state.followers,
            );
          },
        ),
        ProfileInfoCard(
          value: state.followings.length.toString(),
          valueLabel: l10n.profileInfoCardFollowingsCount,
          onTap: () {
            showBottomSheetCreationVariants(
              context: context,
              bottomSheetTitle: l10n.bottomSheetFollowingsTitle,
              users: state.followings,
            );
          },
        ),
      ],
    );
  }

  Widget _postsGrid(BuildContext context, List<PostEntity> posts) {
    return posts.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: Text(context.l10n.profilePageNoPosts)),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];

              return ProfilePostTile(postEntity: post);
            },
          );
  }
}
