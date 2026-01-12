import 'package:flutter/material.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/theme/theme.dart';

class AppError extends StatelessWidget {
  final Object? error;

  const AppError({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Error',
      theme:
          View.of(context).platformDispatcher.platformBrightness ==
              Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                error?.toString() ?? context.l10n.appErrorScreenText,
                textScaler: TextScaler.noScaling,
              ),
            ),
          ),
        ),
      ),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: child!,
      ),
    );
  }
}
