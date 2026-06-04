import 'package:flutter/material.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/date_utils.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

class DueDateChip extends StatelessWidget {
  final TaskEntity task;
  final bool compact;

  const DueDateChip({
    super.key,
    required this.task,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = TaskDateUtils.toRelativeLabel(task.dueDate);
    final urgency = task.isCompleted ? 0 : TaskDateUtils.urgencyLevel(task.dueDate);

    final (color, bgColor, icon) = switch (urgency) {
      2 => (AppColors.error, AppColors.errorLight, Icons.warning_amber_rounded),
      1 => (AppColors.warning, AppColors.warningLight, Icons.schedule_rounded),
      _ => (
          AppColors.textSecondary,
          AppColors.surfaceVariant,
          Icons.calendar_today_rounded,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColors.surfaceVariant : bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 11 : 13,
            color: task.isCompleted ? AppColors.textTertiary : color,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: task.isCompleted ? AppColors.textTertiary : color,
            ),
          ),
        ],
      ),
    );
  }
}