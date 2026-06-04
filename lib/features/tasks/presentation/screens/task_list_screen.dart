import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/snackbar_utils.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_state.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_state.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/empty_tasks_view.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/filter_bottom_sheet.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/task_list_skeleton.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _searchController = TextEditingController();
  int _currentNavIndex = 0;

 @override
void initState() {
  super.initState();

  final authState = context.read<AuthBloc>().state;

  print("AUTH STATE: ${authState.runtimeType}");

  if (authState is AuthAuthenticated) {
    context.read<TaskBloc>().add(
      TasksWatchStarted(authState.user.id),
    );
  } else if (authState is AuthLoginSuccess) {
    context.read<TaskBloc>().add(
      TasksWatchStarted(authState.user.id),
    );
  } else if (authState is AuthRegisterSuccess) {
    context.read<TaskBloc>().add(
      TasksWatchStarted(authState.user.id),
    );
  }
}
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: _handleTaskStateChanges,
        builder: (context, taskState) {
          if (taskState is TasksLoading) {
            return const TaskListSkeleton();
          }

          final tasks = _getTasksFromState(taskState);
          context.read<FilterBloc>().updateTasks(tasks);

          return BlocBuilder<FilterBloc, FilterState>(
            builder: (context, filterState) {
              return _buildBody(context, filterState, taskState);
            },
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBody(
      BuildContext context, FilterState filterState, TaskState taskState) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildSearchBar(context),
        _buildTaskContent(context, filterState, taskState),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final now = DateTime.now();
    final dateStr = DateFormat('d MMM').format(now);
    final dayStr = DateFormat('EEEE').format(now);

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.of(context).padding.top + 16,
          24,
          28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.textOnPrimary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => FilterBottomSheet.show(context),
                  child: BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: state.hasActiveFilters
                              ? AppColors.textOnPrimary
                              : AppColors.textOnPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: state.hasActiveFilters
                              ? AppColors.primary
                              : AppColors.textOnPrimary,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '$dayStr, $dateStr',
              style: const TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'My Tasks',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: TextField(
          controller: _searchController,
          onChanged: (q) =>
              context.read<FilterBloc>().add(FilterSearchChanged(q)),
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.textTertiary, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textTertiary, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      context
                          .read<FilterBloc>()
                          .add(const FilterSearchChanged(''));
                    },
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskContent(
      BuildContext context, FilterState filterState, TaskState taskState) {
    final tasks = filterState.filteredTasks;
    final allTasks = _getTasksFromState(taskState);

    if (tasks.isEmpty && allTasks.isEmpty) {
      return SliverFillRemaining(
        child: EmptyTasksView(
          title: 'No tasks yet',
          body: 'Tap + to add your first task for the day.',
        ),
      );
    }

    if (tasks.isEmpty && filterState.hasActiveFilters) {
      return SliverFillRemaining(
        child: EmptyTasksView(
          title: 'No matching tasks',
          body: 'Try adjusting your filters.',
          isFiltered: true,
          onClearFilters: () =>
              context.read<FilterBloc>().add(const FilterCleared()),
        ),
      );
    }

    final grouped = _groupTasks(tasks);

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 120),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildGroupedList(context, grouped);
          },
          childCount: 1,
        ),
      ),
    );
  }

  Widget _buildGroupedList(
      BuildContext context, Map<String, List<TaskEntity>> grouped) {
    final children = <Widget>[];
    grouped.forEach((label, tasks) {
      children.add(_buildGroupHeader(context, label));
      for (final task in tasks) {
        children.add(_buildTaskRow(context, task));
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildGroupHeader(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildTaskRow(BuildContext context, TaskEntity task) {
    final priorityColor = switch (task.priority) {
      TaskPriority.high => AppColors.priorityHigh,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.low => AppColors.priorityLow,
    };

    final priorityBgColor = switch (task.priority) {
      TaskPriority.high => AppColors.priorityHighLight,
      TaskPriority.medium => AppColors.priorityMediumLight,
      TaskPriority.low => AppColors.priorityLowLight,
    };

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 22),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete task?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) =>
          context.read<TaskBloc>().add(TaskDeleteRequested(task.id)),
      child: GestureDetector(
        onTap: () => context.push('/tasks/${task.id}', extra: task),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context
                    .read<TaskBloc>()
                    .add(TaskToggleCompleteRequested(task)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted
                        ? AppColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.primary
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check_rounded,
                          size: 13, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('d MMM').format(task.dueDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.priority.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push('/tasks/create'),
      elevation: 4,
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomAppBar(
      color: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.primary.withValues(alpha: 0.1),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.list_rounded, 0),
            const SizedBox(width: 60),
            _buildNavItem(Icons.calendar_today_rounded, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primarySurface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textTertiary,
          size: 22,
        ),
      ),
    );
  }

  Map<String, List<TaskEntity>> _groupTasks(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    final Map<String, List<TaskEntity>> groups = {
      'Today': [],
      'Tomorrow': [],
      'This week': [],
      'Later': [],
    };

    for (final task in tasks) {
      final due = DateTime(
          task.dueDate.year, task.dueDate.month, task.dueDate.day);
      if (due.isBefore(today) || due == today) {
        groups['Today']!.add(task);
      } else if (due == tomorrow) {
        groups['Tomorrow']!.add(task);
      } else if (due.isBefore(nextWeek)) {
        groups['This week']!.add(task);
      } else {
        groups['Later']!.add(task);
      }
    }

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  List<TaskEntity> _getTasksFromState(TaskState state) {
    return switch (state) {
      TasksLoaded(:final tasks) => tasks,
      TaskOperationInProgress(:final tasks) => tasks,
      TaskCreateSuccess(:final tasks) => tasks,
      TaskUpdateSuccess(:final tasks) => tasks,
      TaskDeleteSuccess(:final tasks) => tasks,
      TaskToggleSuccess(:final tasks) => tasks,
      TaskFailureState(:final tasks) => tasks,
      _ => [],
    };
  }

  void _handleTaskStateChanges(BuildContext context, TaskState state) {
    switch (state) {
      case TaskCreateSuccess():
        SnackbarUtils.showSuccess(context, 'Task created successfully.');
      case TaskUpdateSuccess():
        SnackbarUtils.showSuccess(context, 'Task updated successfully.');
      case TaskDeleteSuccess():
        SnackbarUtils.showSuccess(context, 'Task deleted.');
      case TaskToggleSuccess(:final task):
        SnackbarUtils.showSuccess(
          context,
          task.isCompleted ? 'Marked as complete.' : 'Marked as incomplete.',
        );
      case TaskFailureState(:final message):
        SnackbarUtils.showError(context, message);
      default:
        break;
    }
  }
}