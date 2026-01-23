import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final IconData leadingIcon;
  final void Function()? onLeadingIconPressed;
  final String actionTitle;
  final void Function()? onActionTap;

  const CustomAppBar({
    super.key,
    required this.appBarTitle,
    required this.leadingIcon,
    this.onLeadingIconPressed,
    required this.actionTitle,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onLeadingIconPressed,
        icon: Icon(leadingIcon),
      ),
      title: Center(child: Text(appBarTitle)),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: onActionTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              actionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
