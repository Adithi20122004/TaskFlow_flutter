import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_state.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<FilterBloc>(),
        child: const FilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              const SizedBox(height: 16),
              _buildHeader(context, state),
              const SizedBox(height: 24),
              _buildSectionLabel(context, 'Priority'),
              const SizedBox(height: 10),
              _buildPriorityChips(context, state),
              const SizedBox(height: 20),
              _buildSectionLabel(context, 'Status'),
              const SizedBox(height: 10),
              _buildStatusChips(context, state),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FilterState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter & Sort',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (state.hasActiveFilters)
          TextButton(
            onPressed: () {
              context.read<FilterBloc>().add(const FilterCleared());
              Navigator.of(context).pop();
            },
            child: const Text('Clear all'),
          ),
      ],
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
    );
  }

  Widget _buildPriorityChips(BuildContext context, FilterState state) {
    return Wrap(
      spacing: 8,
      children: [
        _FilterChip(
          label: 'All',
          selected: state.priorityFilter == null,
          onTap: () => context
              .read<FilterBloc>()
              .add(const FilterPriorityChanged(null)),
        ),
        ...TaskPriority.values.map(
          (p) => _FilterChip(
            label: p.label,
            selected: state.priorityFilter == p,
            color: switch (p) {
              TaskPriority.high => AppColors.priorityHigh,
              TaskPriority.medium => AppColors.priorityMedium,
              TaskPriority.low => AppColors.priorityLow,
            },
            onTap: () => context
                .read<FilterBloc>()
                .add(FilterPriorityChanged(p)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChips(BuildContext context, FilterState state) {
    return Wrap(
      spacing: 8,
      children: [
        _FilterChip(
          label: 'All',
          selected: state.statusFilter == null,
          onTap: () => context
              .read<FilterBloc>()
              .add(const FilterStatusChanged(null)),
        ),
        _FilterChip(
          label: 'Pending',
          selected: state.statusFilter == false,
          onTap: () => context
              .read<FilterBloc>()
              .add(const FilterStatusChanged(false)),
        ),
        _FilterChip(
          label: 'Completed',
          selected: state.statusFilter == true,
          color: AppColors.success,
          onTap: () => context
              .read<FilterBloc>()
              .add(const FilterStatusChanged(true)),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? activeColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}