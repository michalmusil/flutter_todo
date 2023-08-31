import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime? firebaseTimestampToDateTime(Timestamp timestamp) {
    final millis = timestamp.seconds * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  static dateTimeToFirebaseTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  static String getDateString(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(dateTime);
  }

  static String getTimeString(DateTime dateTime) {
    final formatter = DateFormat('hh:mm');
    return formatter.format(dateTime);
  }

  // The returned TimeOfDay is just a bonus to know if the time was picked - the DateTime will contain the time as well if picked, otherwise it will stay default
  static Future<(DateTime, TimeOfDay?)?> showDateTimePicker({
    required BuildContext context,
    required DateTime initialDateTime,
    required DateTime firstDateTime,
    required DateTime lastDateTime,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDateTime,
      lastDate: lastDateTime,
    );

    if (pickedDate == null) return null;

    final initialTime = TimeOfDay.fromDateTime(initialDateTime);

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    return pickedTime == null
        ? (pickedDate, null)
        : (
            DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ),
            pickedTime,
          );
  }
}
