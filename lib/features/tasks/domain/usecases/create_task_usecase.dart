import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/core/utils/validation_utils.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository _repository;

  const CreateTaskUseCase(this._repository);

  Future<Either<Failure, TaskEntity>> call(CreateTaskParams params) async {
    final titleError = ValidationUtils.validateTaskTitle(params.task.title);
    if (titleError != null) {
      return Left(ValidationFailure(titleError));
    }

    final descError =
        ValidationUtils.validateTaskDescription(params.task.description);
    if (descError != null) {
      return Left(ValidationFailure(descError));
    }

    final dueDateError = ValidationUtils.validateDueDate(params.task.dueDate);
    if (dueDateError != null) {
      return Left(ValidationFailure(dueDateError));
    }

    return _repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final TaskEntity task;

  const CreateTaskParams(this.task);

  @override
  List<Object> get props => [task];
}