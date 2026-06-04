import 'package:flutter/material.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, icon) = switch (priority) {
      TaskPriority.high => (
          AppColors.priorityHigh,
          AppColors.priorityHighLight,
          Icons.keyboard_double_arrow_up_rounded,
        ),
      TaskPriority.medium => (
          AppColors.priorityMedium,
          AppColors.priorityMediumLight,
          Icons.remove_rounded,
        ),
      TaskPriority.low => (
          AppColors.priorityLow,
          AppColors.priorityLowLight,
          Icons.keyboard_double_arrow_down_rounded,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: color),
          const SizedBox(width: 3),
          Text(
            priority.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}