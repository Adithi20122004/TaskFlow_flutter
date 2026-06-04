import 'package:gig_tasks/features/tasks/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> watchTasks(String userId);

  Future<List<TaskModel>> getTasks(String userId);

  Future<TaskModel> createTask(TaskModel task);

  Future<TaskModel> updateTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<TaskModel> toggleTaskComplete(TaskModel task);
}