import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final String appBarTitle;
  final IconData leadingIcon;
  final void Function()? onLeadingIconPressed;
  final String actionTitle;
  void Function()? onActionTap;


  CustomAppBar({
    required this.appBarTitle,
    required this.leadingIcon,
    required this.onLeadingIconPressed,
    required this.actionTitle,
    required this.onActionTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onLeadingIconPressed,
        icon: Icon(
          leadingIcon,
        ),
      ),
      title: Center(
          child: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: 18.0,
            ),
          )
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: onActionTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              actionTitle,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }
}