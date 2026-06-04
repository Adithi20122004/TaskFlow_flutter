import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository _repository;

  const GetTasksUseCase(this._repository);

  Future<Either<Failure, List<TaskEntity>>> call(String userId) {
    return _repository.getTasks(userId);
  }
}