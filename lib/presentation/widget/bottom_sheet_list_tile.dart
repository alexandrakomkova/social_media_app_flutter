import 'package:flutter/material.dart';

class BottomSheetListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;

  const BottomSheetListTile({
    required this.icon,
    required this.title,
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25.0,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
