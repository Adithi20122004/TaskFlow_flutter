import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<FilterSearchChanged>(_onSearchChanged);
    on<FilterPriorityChanged>(_onPriorityChanged);
    on<FilterStatusChanged>(_onStatusChanged);
    on<FilterCleared>(_onFilterCleared);
  }

  List<TaskEntity> _allTasks = [];

  /// Called from the UI whenever the TaskBloc emits a new task list.
  void updateTasks(List<TaskEntity> tasks) {
    _allTasks = tasks;
    _applyFilters();
  }

  void _onSearchChanged(
    FilterSearchChanged event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFilters(emit: emit);
  }

  void _onPriorityChanged(
    FilterPriorityChanged event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(priorityFilter: () => event.priority));
    _applyFilters(emit: emit);
  }

  void _onStatusChanged(
    FilterStatusChanged event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(statusFilter: () => event.isCompleted));
    _applyFilters(emit: emit);
  }

  void _onFilterCleared(
    FilterCleared event,
    Emitter<FilterState> emit,
  ) {
    emit(FilterState(filteredTasks: _allTasks));
  }

  void _applyFilters({Emitter<FilterState>? emit}) {
    var result = List<TaskEntity>.from(_allTasks);

    // Search
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              t.description.toLowerCase().contains(q))
          .toList();
    }

    // Priority filter
    if (state.priorityFilter != null) {
      result = result
          .where((t) => t.priority == state.priorityFilter)
          .toList();
    }

    // Status filter
    if (state.statusFilter != null) {
      result = result
          .where((t) => t.isCompleted == state.statusFilter)
          .toList();
    }

    // Sort: overdue first, then by due date ascending
    result.sort((a, b) {
      if (a.isOverdue && !b.isOverdue) return -1;
      if (!a.isOverdue && b.isOverdue) return 1;
      return a.dueDate.compareTo(b.dueDate);
    });

    if (emit != null) {
      emit(state.copyWith(filteredTasks: result));
    } else {
      add(FilterSearchChanged(state.searchQuery));
    }
  }
}