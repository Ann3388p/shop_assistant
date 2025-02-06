import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addMinutes(int minutes) {
    return TimeOfDay(
        hour:  this.hour + (minute + minutes) ~/ 60,
        minute: (minute + minutes) % 60);
  }
}

extension DateTimeExtension on DateTime {
  DateTime setTimeOfDay(TimeOfDay time) {
    return DateTime(this.year, this.month, this.day, time.hour, time.minute);
  }
}