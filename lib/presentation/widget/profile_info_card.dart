import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String value;
  final String valueLabel;

  const ProfileInfoCard({
    required this.value,
    required this.valueLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          valueLabel,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
