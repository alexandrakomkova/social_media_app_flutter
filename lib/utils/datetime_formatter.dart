import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  final BuildContext _context;

  DateTimeFormatter({required BuildContext context}) : _context = context;

  String ddMMyyyyHHmm({required DateTime dateTime}) {
    return DateFormat(
      'dd/MM/yyyy HH:mm',
      Localizations.localeOf(_context).toString(),
    ).format(dateTime);
  }
}
