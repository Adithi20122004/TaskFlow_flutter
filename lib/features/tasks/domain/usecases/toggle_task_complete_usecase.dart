import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';

class ToggleTaskCompleteUseCase {
  final TaskRepository _repository;

  const ToggleTaskCompleteUseCase(this._repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );
    return _repository.toggleTaskComplete(updated);
  }
}