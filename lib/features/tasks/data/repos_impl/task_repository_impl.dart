import 'package:dartz/dartz.dart';
import 'package:gig_tasks/core/errors/exceptions.dart';
import 'package:gig_tasks/core/errors/failures.dart';
import 'package:gig_tasks/features/tasks/data/models/task_model.dart';
import 'package:gig_tasks/features/tasks/data/sources/task_remote_data_source.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  const TaskRepositoryImpl(this._remoteDataSource);

  @override
  Stream<Either<Failure, List<TaskEntity>>> watchTasks(String userId) {
    try {
      return _remoteDataSource.watchTasks(userId).map(
            (models) => Right<Failure, List<TaskEntity>>(
              models.map((m) => m.toEntity()).toList(),
            ),
          );
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId) async {
    try {
      final models = await _remoteDataSource.getTasks(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final model = await _remoteDataSource.createTask(
        TaskModel.fromEntity(task),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final model = await _remoteDataSource.updateTask(
        TaskModel.fromEntity(task),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String taskId) async {
    try {
      await _remoteDataSource.deleteTask(taskId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> toggleTaskComplete(
      TaskEntity task) async {
    try {
      final model = await _remoteDataSource.toggleTaskComplete(
        TaskModel.fromEntity(task),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}