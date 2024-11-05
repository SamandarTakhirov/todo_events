import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String dateFormat() {
    return DateFormat("yyyy-MM-dd").format(this);
  }
}
