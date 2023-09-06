import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/utils/datetime_utils.dart';

class TaskModel {
  String id;
  String userId;
  String name;
  bool done;
  String? description;
  DateTime created;
  DateTime? due;

  TaskModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.created,
    this.due,
    this.done = false,
  });

  static TaskModel? getFromFirestoreInstance(
      String id, Map<String, dynamic> firestoreInstance) {
    try {
      final String userId = firestoreInstance['userId']!;
      final String name = firestoreInstance['name']!;
      final bool done = firestoreInstance['done']!;
      final String? description = firestoreInstance['description'];

      final Timestamp timestampCreated = firestoreInstance['created']!;
      final Timestamp? timeStampDue = firestoreInstance['due'];

      final DateTime created =
          DateTimeUtils.firebaseTimestampToDateTime(timestampCreated)!;
      final DateTime? due = timeStampDue != null
          ? DateTimeUtils.firebaseTimestampToDateTime(timeStampDue)
          : null;

      return TaskModel(
        id: id,
        userId: userId,
        name: name,
        created: created,
        done: done,
        description: description,
        due: due,
      );
    } catch (e) {
      return null;
    }
  }

  TaskModel copyWith({
    String? name,
    bool? done,
  }) {
    return TaskModel(
      id: id,
      userId: userId,
      created: created,
      name: name ?? this.name,
      description: description,
      done: done ?? this.done,
      due: due,
    );
  }
}
