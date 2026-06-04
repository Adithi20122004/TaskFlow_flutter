import 'package:flutter/material.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';

class EmptyTasksView extends StatelessWidget {
  final String title;
  final String body;
  final bool isFiltered;
  final VoidCallback? onClearFilters;

  const EmptyTasksView({
    super.key,
    required this.title,
    required this.body,
    this.isFiltered = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltered
                    ? Icons.filter_list_off_rounded
                    : Icons.check_circle_outline_rounded,
                size: 36,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (isFiltered && onClearFilters != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.filter_list_off_rounded, size: 18),
                label: const Text('Clear Filters'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(160, 44),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}