import 'package:flutter/material.dart';
import 'package:social_media_app/presentation/pages/home/home_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/nav_item.dart';
import 'package:social_media_app/presentation/pages/main_screen/screens.dart';
import 'package:social_media_app/presentation/pages/notifications/notifications_page.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';
import 'package:social_media_app/presentation/pages/search/search_page.dart';
import 'package:social_media_app/presentation/widget/choose_creation_variants.dart';
import 'package:social_media_app/utils/firebase_service.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MainView();
  }
}

class _MainView extends StatefulWidget {
  @override
  State<_MainView> createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  int _currentPage = 0;

  List<NavItem> pages = [
    NavItem(screen: Screens.home, icon: Icons.home, page: HomePage()),
    NavItem(screen: Screens.search, icon: Icons.search, page: SearchPage()),
    NavItem(screen: Screens.create, icon: Icons.add_circle, page: SizedBox()),
    NavItem(
      screen: Screens.notifications,
      icon: Icons.notifications,
      page: NotificationsPage(),
    ),
    NavItem(
      screen: Screens.profile,
      icon: Icons.person,
      page: ProfilePage(userId: FirebaseService.currentUserId),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (NavItem item in pages)
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: IconButton(
                  icon: Icon(
                    item.icon,
                    size: _currentPage == pages.indexOf(item) ? 38 : 24,
                  ),
                  onPressed: () {
                    _navigationTapped(item, context);
                  },
                ),
              ),
          ],
        ),
      ),
      body: pages[_currentPage].page,
    );
  }

  void _navigationTapped(NavItem item, BuildContext context) {
    if (item.screen == Screens.create) {
      return showBottomSheetCreationVariants(context);
    }

    setState(() => _currentPage = pages.indexOf(item));
  }
}
