import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/utils/datetime_utils.dart';

class TasksRepositoryImpl implements ITasksRepository {
  final _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  @override
  Stream<List<TaskModel>> tasksStream() {
    return _tasksCollection
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
  Stream<TaskModel?> taskStream(String taskUuid) {
    return _tasksCollection
        .doc(taskUuid)
        .snapshots(includeMetadataChanges: true)
        .map((documentSnapshot) {
      final data = documentSnapshot.data();
      if (data != null) {
        return TaskModel.getFromFirestoreInstance(documentSnapshot.id, data);
      }
      return null;
    });
  }

  @override
  Future<List<TaskModel>> tasksStatic() async {
    final List<TaskModel> tasks = [];
    final collection = await _tasksCollection.orderBy('due').get();
    for (final item in collection.docs) {
      final task = TaskModel.getFromFirestoreInstance(item.id, item.data());
      if (task != null) {
        tasks.add(task);
      }
    }
    return tasks;
  }

  @override
  Future<TaskModel?> taskStatic(String taskUuid) async {
    final taskSnapshot = await _tasksCollection.doc(taskUuid).get();
    final data = taskSnapshot.data();
    if (data != null) {
      return TaskModel.getFromFirestoreInstance(taskSnapshot.id, data);
    }
    return null;
  }

  @override
  Future<bool> addTask(TaskModel task) async {
    final created = DateTimeUtils.dateTimeToFirebaseTimestamp(task.created);
    final due = (task.due != null)
        ? DateTimeUtils.dateTimeToFirebaseTimestamp(task.due!)
        : null;
    try {
      await _tasksCollection.add({
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
  Future<bool> updateTask(TaskModel task) async {
    final created = DateTimeUtils.dateTimeToFirebaseTimestamp(task.created);
    final due = (task.due != null)
        ? DateTimeUtils.dateTimeToFirebaseTimestamp(task.due!)
        : null;
    try {
      await _tasksCollection.doc(task.uuid).update({
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
      await _tasksCollection.doc(task.uuid).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
