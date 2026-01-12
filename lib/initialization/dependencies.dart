import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show BuildContext, Widget, Key;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:social_media_app/initialization/inherited_dependencies.dart';

class Dependencies {
  Dependencies();

  factory Dependencies.of(BuildContext context) =>
      InheritedDependencies.of(context);

  Widget inject({required Widget child, Key? key}) =>
      InheritedDependencies(dependencies: this, key: key, child: child);

  late final SharedPreferences sharedPreferences;
}
