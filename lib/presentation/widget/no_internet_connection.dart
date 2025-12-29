import 'package:flutter/material.dart';
import 'package:social_media_app/l10n/l10n.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.noInternetConnectionText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.primary
              ),
            ),
          ],
        ),
      )
    );
  }
}