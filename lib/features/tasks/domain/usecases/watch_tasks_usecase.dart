import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';

class WatchTasksUseCase {
  final TaskRepository _repository;

  const WatchTasksUseCase(this._repository);

  Stream<Either<Failure, List<TaskEntity>>> call(String userId) {
    return _repository.watchTasks(userId);
  }
}