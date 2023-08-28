import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/model/repositories/itasks_repository.dart';
import 'package:todo_list/model/tasks/task_model.dart';
import 'package:todo_list/services/auth/auth_service_impl.dart';
import 'package:todo_list/services/auth/iauth_service.dart';
import 'package:todo_list/utils/datetime_utils.dart';

class TasksRepositoryImpl implements ITasksRepository {
  final IAuthService _authService = AuthServiceImpl();
  final _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  @override
  Stream<List<TaskModel>> tasksStream() {
    final user = _authService.user;
    if (user == null) {
      return const Stream.empty();
    }

    return _tasksCollection
        .where('userId', isEqualTo: user.uuid)
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
    final user = _authService.user;
    if (user == null) {
      return const Stream.empty();
    }

    return _tasksCollection
        .doc(taskUuid)
        .snapshots(includeMetadataChanges: true)
        .map((documentSnapshot) {
      final data = documentSnapshot.data();
      if (data != null && data['userId'] == user.uuid) {
        return TaskModel.getFromFirestoreInstance(documentSnapshot.id, data);
      }
      return null;
    });
  }

  @override
  Future<List<TaskModel>> tasksStatic() async {
    final user = _authService.user;
    if (user == null) {
      return [];
    }

    final List<TaskModel> tasks = [];
    final collection = await _tasksCollection
        .where('userId', isEqualTo: user.uuid)
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
  Future<TaskModel?> taskStatic(String taskUuid) async {
    final user = _authService.user;
    if (user == null) {
      return null;
    }

    final taskSnapshot = await _tasksCollection.doc(taskUuid).get();
    final data = taskSnapshot.data();
    if (data != null && data['userId'] == user.uuid) {
      return TaskModel.getFromFirestoreInstance(taskSnapshot.id, data);
    }
    return null;
  }

  @override
  Future<bool> addTask(TaskModel task) async {
    final userId = _authService.user?.uuid;
    if (userId == null) {
      return false;
    }

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
