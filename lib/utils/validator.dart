import 'package:flutter/material.dart';
import 'package:social_media_app/l10n/app_localizations.dart';

class Validator {
  final BuildContext _context;

  Validator({required BuildContext context}) : _context = context;

  late final l10n = AppLocalizations.of(_context);

  String? validateComment(String? text) {
    if (text == null || text.length < 3) {
      return l10n.validationCommentEmpty;
    }

    return null;
  }

  String? validateEmail(String? email) {
    if (email == null) {
      return l10n.validationEmailEmpty;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return l10n.validationEmailInvalid;
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.length < 6) {
      return l10n.validationPasswordLength;
    }

    return null;
  }

  String? validateRepeatPassword(String? password, String? repeatPassword) {
    if (password != repeatPassword) {
      return l10n.validationRepeatPasswordNotEqualToPassword;
    }

    return null;
  }

  String? validateUsername(String? username) {
    if (username == null || username.length < 3) {
      return l10n.validationUsernameLength;
    }

    return null;
  }
}
