import 'package:equatable/equatable.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

class FilterState extends Equatable {
  final String searchQuery;
  final TaskPriority? priorityFilter;

  /// null = all, true = completed only, false = pending only
  final bool? statusFilter;
  final List<TaskEntity> filteredTasks;

  const FilterState({
    this.searchQuery = '',
    this.priorityFilter,
    this.statusFilter,
    this.filteredTasks = const [],
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      priorityFilter != null ||
      statusFilter != null;

  FilterState copyWith({
    String? searchQuery,
    TaskPriority? Function()? priorityFilter,
    bool? Function()? statusFilter,
    List<TaskEntity>? filteredTasks,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      priorityFilter:
          priorityFilter != null ? priorityFilter() : this.priorityFilter,
      statusFilter:
          statusFilter != null ? statusFilter() : this.statusFilter,
      filteredTasks: filteredTasks ?? this.filteredTasks,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        priorityFilter,
        statusFilter,
        filteredTasks,
      ];
}