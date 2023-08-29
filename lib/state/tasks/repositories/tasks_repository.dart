import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/state/tasks/repositories/tasks_repository_base.dart';
import 'package:todo_list/state/tasks/models/task_model.dart';
import 'package:todo_list/utils/datetime_utils.dart';


class TasksRepository implements TasksRepositoryBase {
  final _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  @override
  Stream<Iterable<TaskModel>> tasksStream({required String userId}) {

    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('due')
        .snapshots(includeMetadataChanges: true)
        .map((querySnapshot) {
      final List<TaskModel> tasks = [];
      for (var taskItem in querySnapshot.docs) {
        final task =
            TaskModel.getFromFirestoreInstance(taskItem.id, taskItem.data());
        if (task != null) {
          tasks.add(task);
        }
      }
      return tasks;
    });
  }

  @override
  Stream<TaskModel?> taskStream({required String userId, required String taskId}) {
    return _tasksCollection
        .doc(taskId)
        .snapshots(includeMetadataChanges: true)
        .map((documentSnapshot) {
      final data = documentSnapshot.data();
      if (data != null && data['userId'] == userId) {
        return TaskModel.getFromFirestoreInstance(documentSnapshot.id, data);
      }
      return null;
    });
  }

  @override
  Future<Iterable<TaskModel>> tasksStatic({required String userId}) async {
    final List<TaskModel> tasks = [];
    final collection = await _tasksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('due')
        .get();
    for (final item in collection.docs) {
      final task = TaskModel.getFromFirestoreInstance(item.id, item.data());
      if (task != null) {
        tasks.add(task);
      }
    }
    return tasks;
  }

  @override
  Future<TaskModel?> taskStatic({required String userId, required String taskId}) async {
    final taskSnapshot = await _tasksCollection.doc(taskId).get();
    final data = taskSnapshot.data();
    if (data != null && data['userId'] == userId) {
      return TaskModel.getFromFirestoreInstance(taskSnapshot.id, data);
    }
    return null;
  }

  @override
  Future<bool> addTask({required String userId, required TaskModel task}) async {
    final created = DateTimeUtils.dateTimeToFirebaseTimestamp(task.created);
    final due = (task.due != null)
        ? DateTimeUtils.dateTimeToFirebaseTimestamp(task.due!)
        : null;
    try {
      await _tasksCollection.add({
        'name': task.name,
        'userId': userId,
        'done': task.done,
        'created': created,
        'description': task.description,
        'due': due
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateTask(TaskModel task) async {
    final created = DateTimeUtils.dateTimeToFirebaseTimestamp(task.created);
    final due = (task.due != null)
        ? DateTimeUtils.dateTimeToFirebaseTimestamp(task.due!)
        : null;
    try {
      await _tasksCollection.doc(task.id).update({
        'name': task.name,
        'done': task.done,
        'created': created,
        'description': task.description,
        'due': due
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
