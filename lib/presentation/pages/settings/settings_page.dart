import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/presentation/pages/edit_profile/edit_profile_page.dart';
import 'package:social_media_app/theme/theme.dart';
import 'package:social_media_app/theme/theme_provider.dart';

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
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Edit profile',
                style: SocialMediaTheme.settingListTileTextStyle,
              ),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Dark mode',
                style: SocialMediaTheme.settingListTileTextStyle,
              ),
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) => Switch(
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                  value: themeProvider.isDarkMode,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
