import 'package:flutter/material.dart'
    as material
    show WidgetsFlutterBinding, WidgetsBinding, GlobalKey, NavigatorState;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/initialization/dependencies.dart';
import 'package:social_media_app/initialization/initialize_dependencies.dart';
import 'package:social_media_app/utils/notification_handler.dart';

final _log = Logger('initializeApp');

Future<void> $initializeApp({
  required Future<void> Function(Dependencies dependencies)? onSuccess,
  void Function(Object error)? onError,
  required material.GlobalKey<material.NavigatorState> navigatorKey,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
}) async {
  late final material.WidgetsBinding binding;

  try {
    binding = material.WidgetsFlutterBinding.ensureInitialized()
      ..deferFirstFrame();

    final NotificationHandler notificationHandler = NotificationHandler(
      navigatorKey,
    );

    final dependencies = await $initializeDependencies(
      notificationHandler: notificationHandler,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );

    await onSuccess?.call(dependencies);
  } on Object catch (e) {
    _log.warning('Error while App initialization: $e');
    onError?.call(e);
  } finally {
    binding.addPostFrameCallback((_) {
      binding.allowFirstFrame();
    });
    _log.info('App initialized successfully');
  }
}
