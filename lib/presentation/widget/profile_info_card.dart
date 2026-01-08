import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String value;
  final String valueLabel;
  final void Function()? onTap;

  const ProfileInfoCard({
    super.key,
    required this.value,
    required this.valueLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(valueLabel, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
