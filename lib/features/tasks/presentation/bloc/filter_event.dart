import 'package:equatable/equatable.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

final class FilterSearchChanged extends FilterEvent {
  final String query;

  const FilterSearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

final class FilterPriorityChanged extends FilterEvent {
  final TaskPriority? priority;

  const FilterPriorityChanged(this.priority);

  @override
  List<Object?> get props => [priority];
}

final class FilterStatusChanged extends FilterEvent {
  /// null = all, true = completed, false = pending
  final bool? isCompleted;

  const FilterStatusChanged(this.isCompleted);

  @override
  List<Object?> get props => [isCompleted];
}

final class FilterCleared extends FilterEvent {
  const FilterCleared();
}