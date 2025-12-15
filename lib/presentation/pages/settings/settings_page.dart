import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/l10n/language_provider.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
            l10n.settingsPageLabel,
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
                l10n.editProfileLabel,
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
                l10n.darkModeLabel,
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
            ),
            // Text(
            //     'Language',
            //   style: SocialMediaTheme.settingListTileTextStyle,
            // ),
            // Expanded(
            //   child: Consumer<LanguageProvider>(
            //     builder: (context, languageProvider, child) =>
            //       ListView(
            //         children: [
            //           ListTile(
            //             title: Text('English'),
            //             onTap: () {
            //               languageProvider.setLocale(Locale('en'));
            //             },
            //             selected: languageProvider.locale.languageCode == 'en',
            //           ),
            //           ListTile(
            //             title: Text('Русский'),
            //             onTap: () {
            //               languageProvider.setLocale(Locale('ru'));
            //             },
            //             selected: languageProvider.locale.languageCode == 'ru',
            //           ),
            //         ],
            //       ),
            //   )
            // )

            ListTile(
              title: Text(
                'Language',
                style: SocialMediaTheme.settingListTileTextStyle,
              ),
              trailing: Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) =>
                  DropdownButton(
                    value: languageProvider.locale,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ['en', 'ru'].map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),

                    onChanged: (newValue) {
                      languageProvider.setLocale(Locale(newValue.toString()));
                    }
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
