extension DateTimeExtensions on DateTime {
  String get dateOnly {
    return '$year-$month-$day';
  }

  String get dayMonthYear {
    return '$day/$month/$year';
  }
}