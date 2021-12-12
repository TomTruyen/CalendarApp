extension DateOnlyCompare on DateTime {
  bool isBeforeDate(DateTime other) {
    return DateTime(year, month, day).isBefore(
      DateTime(other.year, other.month, other.day),
    );
  }
}
