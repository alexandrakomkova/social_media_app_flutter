import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (profileContext) =>
        ProfileBloc(
            authRepository: profileContext.read<AuthRepositoryImpl>(),
        ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile'),
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
            )
          ],
        ),
      ),
    );
  }
}

