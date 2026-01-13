import 'package:flutter/material.dart';
import 'package:social_media_app/presentation/pages/main_screen/screens.dart';

class NavItem {
  final IconData icon;
  final Widget page;
  final Screens screen;

  const NavItem({required this.icon, required this.page, required this.screen});
}
