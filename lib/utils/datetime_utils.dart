import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';

class DateTimeUtils {
  
  static DateTime? firebaseTimestampToDateTime(Timestamp timestamp) {
    final millis = timestamp.seconds * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  static dateTimeToFirebaseTimestamp(DateTime dateTime){
    return Timestamp.fromDate(dateTime);
  }

  static String getDateString(DateTime dateTime){
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(dateTime);
  }

  static String getTimeString(DateTime dateTime){
    final formatter = DateFormat('hh:mm');
    return formatter.format(dateTime);
  }
}
