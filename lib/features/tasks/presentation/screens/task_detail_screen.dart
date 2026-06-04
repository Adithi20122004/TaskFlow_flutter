import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/constants/app_strings.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/date_utils.dart';
import 'package:gig_tasks/core/utils/snackbar_utils.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_state.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/due_date_chip.dart';
import 'package:gig_tasks/features/tasks/presentation/widgets/priority_badge.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskDeleteSuccess) {
          SnackbarUtils.showSuccess(context, AppStrings.taskDeleted);
          context.go('/tasks');
        }
        if (state is TaskToggleSuccess) {
          SnackbarUtils.showSuccess(
            context,
            state.task.isCompleted
                ? AppStrings.taskCompleted
                : AppStrings.taskReopened,
          );
          context.pop();
        }
        if (state is TaskFailureState) {
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.taskDetail),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('/tasks/${task.id}/edit', extra: task),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBanner(context),
              const SizedBox(height: 20),
              _buildTitle(context),
              const SizedBox(height: 16),
              _buildMetaRow(context),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildDescription(context),
              ],
              const SizedBox(height: 24),
              _buildTimestamps(context),
              const SizedBox(height: 32),
              _buildToggleButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
    if (task.isCompleted) {
      return _buildBanner(
        context,
        color: AppColors.success,
        bgColor: AppColors.successLight,
        icon: Icons.check_circle_rounded,
        label: 'Completed',
      );
    }
    if (task.isOverdue) {
      return _buildBanner(
        context,
        color: AppColors.error,
        bgColor: AppColors.errorLight,
        icon: Icons.warning_amber_rounded,
        label: 'Overdue',
      );
    }
    if (task.isDueToday) {
      return _buildBanner(
        context,
        color: AppColors.warning,
        bgColor: AppColors.warningLight,
        icon: Icons.schedule_rounded,
        label: 'Due today',
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBanner(
    BuildContext context, {
    required Color color,
    required Color bgColor,
    required IconData icon,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      task.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? AppColors.completedText
                : AppColors.textPrimary,
          ),
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    return Row(
      children: [
        PriorityBadge(priority: task.priority),
        const SizedBox(width: 8),
        DueDateChip(task: task),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          task.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildTimestamps(BuildContext context) {
    return Column(
      children: [
        _buildTimestampRow(
          context,
          label: 'Created',
          value: TaskDateUtils.toDisplayDate(task.createdAt),
        ),
        const SizedBox(height: 6),
        _buildTimestampRow(
          context,
          label: 'Last updated',
          value: TaskDateUtils.toDisplayDate(task.updatedAt),
        ),
      ],
    );
  }

  Widget _buildTimestampRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => context
          .read<TaskBloc>()
          .add(TaskToggleCompleteRequested(task)),
      icon: Icon(
        task.isCompleted
            ? Icons.refresh_rounded
            : Icons.check_circle_outline_rounded,
        size: 20,
      ),
      label: Text(
        task.isCompleted
            ? AppStrings.markIncomplete
            : AppStrings.markComplete,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor:
            task.isCompleted ? AppColors.textSecondary : AppColors.success,
        side: BorderSide(
          color: task.isCompleted ? AppColors.border : AppColors.success,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<TaskBloc>()
                  .add(TaskDeleteRequested(task.id));
            },
            style: TextButton.styleFrom(
                foregroundColor: AppColors.error),
            child: const Text(AppStrings.deleteConfirmButton),
          ),
        ],
      ),
    );
  }
}