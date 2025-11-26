import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';
import 'package:social_media_app/presentation/widget/profile_info_card.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({
    this.userId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (profileContext) =>
        ProfileBloc.getUserInfo(
          authRepository: profileContext.read<AuthRepositoryImpl>(),
          id: userId
        ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({super.key});

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
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {
                context.read<ProfileBloc>().add(ProfileEvent.signOut());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SignInPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
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
                          value: '123',
                          valueLabel: 'posts',
                        ),
                        //SizedBox(width: 10.0,),
                        ProfileInfoCard(
                          value: '17',
                          valueLabel: 'followers',
                        ),
                        //SizedBox(width: 10.0,),
                        ProfileInfoCard(
                          value: '54',
                          valueLabel: 'following',
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
                  ],
                ),
              ),
            };
          },
        )
    );
  }
}

