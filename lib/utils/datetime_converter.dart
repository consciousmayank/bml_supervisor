import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StringToDateTimeConverter {
  String format;
  final String date;

  StringToDateTimeConverter.ddmmyy({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy';
  }

  StringToDateTimeConverter.ddmmyyhhmm({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy hh:mm';
  }

  StringToDateTimeConverter.ddmmyyhhmmss({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy hh:mm:ss';
  }

  StringToDateTimeConverter.ddmmyyhhmmssaa({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy hh:mm:ss aa';
  }

  DateTime convert() {
    if (this.date != null) {
      return DateTime.parse(
        DateFormat(this.format, "en_US").parse(date).toString(),
      );
    } else {
      return null;
    }
  }
}

class DateTimeToStringConverter {
  String format;
  final DateTime date;

  DateTimeToStringConverter.ddmmyy({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy';
  }

  DateTimeToStringConverter.ddmmyyhhmm({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy hh:mm';
  }

  DateTimeToStringConverter.ddmmyyhhmmss({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy hh:mm:ss';
  }

  DateTimeToStringConverter.ddmmyyhhmmssaa({
    @required this.date,
  }) {
    this.format = 'dd-MM-yyyy hh:mm:ss aa';
  }

  String convert() {
    return DateFormat(this.format).format(this.date);
  }
}
