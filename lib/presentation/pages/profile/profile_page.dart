import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/domain/model/post_entity.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/pages/settings/settings_page.dart';
import 'package:social_media_app/presentation/widget/bottom_sheet_followers_followings_list.dart';
import 'package:social_media_app/presentation/widget/custom_alert_dialog.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';
import 'package:social_media_app/presentation/widget/profile_info_card.dart';
import 'package:social_media_app/presentation/widget/profile_post_tile.dart';
import 'package:social_media_app/utils/firebase_utils.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({
    required this.userId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (profileContext) =>
        ProfileBloc.getUserProfile(
          authRepository: profileContext.read<AuthRepositoryImpl>(),
          profileRepository: profileContext.read<ProfileRepositoryImpl>(),
          id: userId
        ),
      child: _ProfileView(userId: userId),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final String? userId;

  const _ProfileView({
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return Text(
                    state.user?.username ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
          actions: userId == FirebaseUtils.currentUserId
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(),
                      ),
                    );
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
            return switch(state.status) {
              ProfileStatus.idle => SizedBox(),
              ProfileStatus.processing => Center( child: CircularProgressIndicator()),
              ProfileStatus.failed => Center( child: Text('something went wrong')),
              ProfileStatus.success => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // profile head
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProfileAvatar(
                          radius: 45.0,
                          userEntity: state.user ?? UserEntity(),
                        ),
                        ProfileInfoCard(
                          value: state.posts.length.toString(),
                          valueLabel: 'posts',
                        ),
                        //SizedBox(width: 10.0,),
                        ProfileInfoCard(
                          value: state.followers.length.toString(),
                          valueLabel: 'followers',
                          onTap: () {
                            showBottomSheetCreationVariants(
                                context: context,
                                bottomSheetTitle: 'Followers',
                                users: state.followers
                            );
                          },
                        ),
                        //SizedBox(width: 10.0,),
                        ProfileInfoCard(
                          value: state.followings.length.toString(),
                          valueLabel: 'following',
                          onTap: () {
                            showBottomSheetCreationVariants(
                                context: context,
                                bottomSheetTitle: 'Following',
                                users: state.followings
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            state.user?.bio ?? '',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10.0,),
                    // 'all posts' title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'All posts',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10.0,),
                    // pics grid
                    _postGrid(context, state.posts),


                  ],
                ),
              ),
            };
          },
        )
    );
  }

  void _showLogoutAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        dialogTitle: 'Logout',
        dialogContent: 'Are you sure you want to logout?',
        rightButtonTitle: 'Continue',
        onRightPressed: () {
          context.read<ProfileBloc>().add(ProfileEvent.signOut());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => SignInPage(),
            ),
              (route) => false
          );
        },
        leftButtonTitle: 'Cancel',
        onLeftPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

Widget _postGrid(
    BuildContext context,
    List<PostEntity> posts
) {
  return posts.isEmpty
      ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text('No posts found'),
        ),
      )
      : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];

            return ProfilePostTile(
              postEntity: post,
            );
          },
        );
}