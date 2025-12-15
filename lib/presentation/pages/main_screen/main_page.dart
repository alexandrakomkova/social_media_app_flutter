import 'package:flutter/material.dart';
import 'package:social_media_app/presentation/pages/home/home_page.dart';
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

  List pages = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'page': HomePage(),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': Icons.search,
      'page': SearchPage(),
      'index': 1,
    },
    {
      'title': 'Add post',
      'icon': Icons.add_circle,
      'page': Text(''),
      'index': 2,
    },
    {
      'title': 'Notification',
      'icon': Icons.notifications,
      'page': NotificationsPage(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
      'page': ProfilePage(userId: FirebaseService.currentUserId),
      'index': 4,
    },
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
            for (Map item in pages)
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: IconButton(
                  icon: Icon(
                    item['icon'],
                    size: _currentPage == item['index'] ? 38 : 24,
                  ),
                  onPressed: () {
                     _navigationTapped(item['index'], context);
                  },
                ),
              ),
          ],
        ),
      ),
      body: pages[_currentPage]['page']
    );
  }

  void _navigationTapped(int page, BuildContext context) {
    setState(() {
      if(page == 2) {
        showBottomSheetCreationVariants(context);
      } else {
        _currentPage = page;
      }
    });
  }
}

