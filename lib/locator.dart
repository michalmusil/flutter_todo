import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/data/repositories/tasks_repository.dart';
import 'package:todo_list/data/services/auth_service.dart';
import 'package:todo_list/domain/repositories/tasks_repository_base.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  // Auth service
  final firebaseAuthInstance = FirebaseAuth.instance;
  final authService = AuthService(firebaseAuthInstance);
  locator.registerSingleton<AuthServiceBase>(authService);

  // Tasks repository
  final firestoreInstance = FirebaseFirestore.instance;
  final tasksRepository = TasksRepository(firestoreInstance);
  locator.registerSingleton<TasksRepositoryBase>(tasksRepository);
}