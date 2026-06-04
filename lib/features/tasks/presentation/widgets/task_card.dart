import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_event.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/due_date_chip.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;

  const TaskCard({super.key, required this.task});

  Color get _priorityBorderColor => switch (task.priority) {
        TaskPriority.high => AppColors.priorityHigh,
        TaskPriority.medium => AppColors.priorityMedium,
        TaskPriority.low => AppColors.priorityLow,
      };

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        context
            .read<TaskBloc>()
            .add(TaskDeleteRequested(task.id));
      },
      child: GestureDetector(
        onTap: () => context.push('/tasks/${task.id}', extra: task),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: isCompleted
                    ? AppColors.border
                    : _priorityBorderColor,
                width: 4,
              ),
              top: BorderSide(color: AppColors.border),
              right: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckbox(context),
                const SizedBox(width: 12),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<TaskBloc>()
          .add(TaskToggleCompleteRequested(task)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.isCompleted ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: task.isCompleted ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check_rounded,
                size: 14, color: AppColors.textOnPrimary)
            : null,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isCompleted = task.isCompleted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? AppColors.completedText
                    : AppColors.textPrimary,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (task.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            task.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isCompleted
                      ? AppColors.textTertiary
                      : AppColors.textSecondary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            PriorityBadge(priority: task.priority, compact: true),
            const SizedBox(width: 6),
            DueDateChip(task: task, compact: true),
          ],
        ),
      ],
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded,
              color: AppColors.textOnPrimary, size: 24),
          SizedBox(height: 2),
          Text(
            'Delete',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text(
          'This task will be permanently deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
                foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}