import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/snackbar_utils.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_event.dart';
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
    if (authState is AuthAuthenticated) {
      context.read<TaskBloc>().add(TasksWatchStarted(authState.user.id));
    } else if (authState is AuthLoginSuccess) {
      context.read<TaskBloc>().add(TasksWatchStarted(authState.user.id));
    } else if (authState is AuthRegisterSuccess) {
      context.read<TaskBloc>().add(TasksWatchStarted(authState.user.id));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

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

  // ─────────────────────────────────────────────
  // BODY — switches between list and calendar
  // ─────────────────────────────────────────────

  Widget _buildBody(
      BuildContext context, FilterState filterState, TaskState taskState) {
    if (_currentNavIndex == 1) {
      // ── CALENDAR VIEW ──
      final tasks = filterState.filteredTasks;
      return CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: tasks.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No tasks scheduled',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildCalendarView(context, tasks),
                      childCount: 1,
                    ),
                  ),
          ),
        ],
      );
    }

    // ── LIST VIEW (default) ──
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildSearchBar(context),
        _buildTaskContent(context, filterState, taskState),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // HEADER (with profile icon + filter icon)
  // ─────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('d MMM').format(now);
    final dayStr = DateFormat('EEEE').format(now);

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
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
                // ── TOP-LEFT: profile icon ──
                GestureDetector(
                  onTap: () => _showProfileSheet(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                // ── TOP-RIGHT: filter icon ──
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

  // ─────────────────────────────────────────────
  // PROFILE SHEET
  // ─────────────────────────────────────────────

  void _showProfileSheet(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userName = authState is AuthAuthenticated
    ? (authState.user.displayName ?? authState.user.email)
    : 'User';
    final userEmail =
        authState is AuthAuthenticated ? authState.user.email : '';
    final initials = userName.trim().isNotEmpty
        ? userName
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<AuthBloc>()
                      .add(const AuthLogoutRequested());
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 18,
                ),
                label: const Text(
                  'Sign out',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────

Widget _buildSearchBar(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimary,
          fontSize: 14,
        ),
        onChanged: (q) =>
            context.read<FilterBloc>().add(FilterSearchChanged(q)),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<FilterBloc>()
                        .add(const FilterSearchChanged(''));
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    ),
  );
}

  // ─────────────────────────────────────────────
  // TASK CONTENT (list view)
  // ─────────────────────────────────────────────

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
          (context, index) => _buildGroupedList(context, grouped),
          childCount: 1,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CALENDAR VIEW
  // ─────────────────────────────────────────────

  Widget _buildCalendarView(BuildContext context, List<TaskEntity> tasks) {
    final Map<String, List<TaskEntity>> byDate = {};
    for (final task in tasks) {
      final key = DateFormat('EEE, d MMM yyyy').format(task.dueDate);
      byDate.putIfAbsent(key, () => []).add(task);
    }

    final sortedKeys = byDate.keys.toList()
      ..sort((a, b) {
        final df = DateFormat('EEE, d MMM yyyy');
        return df.parse(a).compareTo(df.parse(b));
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedKeys.map((dateLabel) {
        final dayTasks = byDate[dateLabel]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${dayTasks.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...dayTasks.map((t) => _buildTaskRow(context, t)),
          ],
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  // GROUPED LIST HELPERS
  // ─────────────────────────────────────────────

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

  // ─────────────────────────────────────────────
  // TASK ROW
  // ─────────────────────────────────────────────

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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  // ─────────────────────────────────────────────
  // FAB + BOTTOM NAV
  // ─────────────────────────────────────────────

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
          color: isSelected ? AppColors.primarySurface : Colors.transparent,
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

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

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
      final due =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
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