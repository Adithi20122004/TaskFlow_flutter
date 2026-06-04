import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  /// Returns a real-time stream of all tasks for the given user.
  Stream<Either<Failure, List<TaskEntity>>> watchTasks(String userId);

  /// Fetches all tasks once for the given user.
  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId);

  /// Creates a new task in Firestore.
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);

  /// Updates an existing task in Firestore.
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);

  /// Deletes a task by ID.
  Future<Either<Failure, Unit>> deleteTask(String taskId);

  /// Toggles the isCompleted field of a task.
  Future<Either<Failure, TaskEntity>> toggleTaskComplete(TaskEntity task);
}