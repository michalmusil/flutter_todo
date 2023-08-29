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

  static final List<TaskModel> mockData = [
    TaskModel(
      id: "asdfasdfasdf",
      userId: "1",
      name:
          "Wash the dishes and then bust my shit, stroke my shit, put lotion on my dick, horny as fuuck maan!",
      created: DateTime.fromMillisecondsSinceEpoch(1640958000000),
      description: "I'm gonna wash the dished today",
      due: DateTime.now(),
    ),
    TaskModel(
      id: "a14sd65fr",
      userId: "1",
      name: "Take the dog for a walk",
      created: DateTime.fromMillisecondsSinceEpoch(1640978000150),
      description: null,
      due: DateTime.fromMillisecondsSinceEpoch(1641008011150),
    ),
    TaskModel(
      id: "rguhaqrpiuegfhbnl",
      userId: "1",
      name: "Clean the carpets",
      created: DateTime.now(),
      description:
          "With a very strong chemical solution that will lorem ipsum.",
    ),
  ];
}
