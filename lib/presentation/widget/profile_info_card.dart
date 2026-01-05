import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String value;
  final String valueLabel;
  final void Function()? onTap;

  const ProfileInfoCard({
    required this.value,
    required this.valueLabel,
    this.onTap,
    super.key,
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
