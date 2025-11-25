import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/widget/profile_info.dart';

class ProfilePage extends StatelessWidget {
  String? userId;

  ProfilePage({
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
      // ProfileBloc(
      //     authRepository: profileContext.read<AuthRepositoryImpl>()
      // )..add(ProfileEvent.getUserInfo(userId)),
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
                return Text(state.user?.email ?? '');
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
            return Column(
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: Image.network(
                    //       state.user?.photoUrl ?? ''
                    //   ),
                    // ),
                    Text(
                      state.user?.username ?? ''
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        state.user?.bio ?? '',
                    )
                  ],
                )
              ],
            );
          },
        )
    );
  }
}

