import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository _repository;

  const DeleteTaskUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String taskId) {
    return _repository.deleteTask(taskId);
  }
}