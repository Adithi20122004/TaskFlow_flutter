import 'package:equatable/equatable.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Start watching the real-time task stream for a user.
final class TasksWatchStarted extends TaskEvent {
  final String userId;

  const TasksWatchStarted(this.userId);

  @override
  List<Object> get props => [userId];
}

/// Internal event fired when the Firestore stream emits new data.
final class TasksUpdated extends TaskEvent {
  final List<TaskEntity> tasks;

  const TasksUpdated(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// Internal event fired when the Firestore stream emits an error.
final class TasksStreamErrored extends TaskEvent {
  final String message;

  const TasksStreamErrored(this.message);

  @override
  List<Object> get props => [message];
}

/// Create a new task.
final class TaskCreateRequested extends TaskEvent {
  final TaskEntity task;

  const TaskCreateRequested(this.task);

  @override
  List<Object> get props => [task];
}

/// Update an existing task.
final class TaskUpdateRequested extends TaskEvent {
  final TaskEntity task;

  const TaskUpdateRequested(this.task);

  @override
  List<Object> get props => [task];
}

/// Delete a task by ID.
final class TaskDeleteRequested extends TaskEvent {
  final String taskId;

  const TaskDeleteRequested(this.taskId);

  @override
  List<Object> get props => [taskId];
}

/// Toggle completion status.
final class TaskToggleCompleteRequested extends TaskEvent {
  final TaskEntity task;

  const TaskToggleCompleteRequested(this.task);

  @override
  List<Object> get props => [task];
}