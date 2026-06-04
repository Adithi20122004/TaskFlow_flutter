import 'package:equatable/equatable.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any load.
final class TaskInitial extends TaskState {
  const TaskInitial();
}

/// Tasks are being loaded for the first time.
final class TasksLoading extends TaskState {
  const TasksLoading();
}

/// Tasks loaded successfully — holds the full unfiltered list.
final class TasksLoaded extends TaskState {
  final List<TaskEntity> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// A task operation (create/update/delete/toggle) is in progress.
/// Carries the current task list so the UI doesn't blank out.
final class TaskOperationInProgress extends TaskState {
  final List<TaskEntity> tasks;

  const TaskOperationInProgress(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// A task was created successfully.
final class TaskCreateSuccess extends TaskState {
  final TaskEntity task;
  final List<TaskEntity> tasks;

  const TaskCreateSuccess({required this.task, required this.tasks});

  @override
  List<Object> get props => [task, tasks];
}

/// A task was updated successfully.
final class TaskUpdateSuccess extends TaskState {
  final TaskEntity task;
  final List<TaskEntity> tasks;

  const TaskUpdateSuccess({required this.task, required this.tasks});

  @override
  List<Object> get props => [task, tasks];
}

/// A task was deleted successfully.
final class TaskDeleteSuccess extends TaskState {
  final List<TaskEntity> tasks;

  const TaskDeleteSuccess(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// A task's completion was toggled successfully.
final class TaskToggleSuccess extends TaskState {
  final TaskEntity task;
  final List<TaskEntity> tasks;

  const TaskToggleSuccess({required this.task, required this.tasks});

  @override
  List<Object> get props => [task, tasks];
}

/// An error occurred during a task operation.
final class TaskFailureState extends TaskState {
  final String message;
  final List<TaskEntity> tasks;

  const TaskFailureState({required this.message, required this.tasks});

  @override
  List<Object> get props => [message, tasks];
}