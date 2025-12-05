import 'package:flutter/material.dart';
import 'package:social_media_app/presentation/pages/edit_profile/edit_profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsView();
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
            'Settings',
            style: TextStyle(
              fontSize: 20.0,
            ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(),
                    ),
                  );
                },
                child: Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
