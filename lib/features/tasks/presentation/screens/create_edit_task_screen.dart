import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/core/constants/app_strings.dart';
import 'package:gig_tasks/core/theme/app_colors.dart';
import 'package:gig_tasks/core/utils/date_utils.dart';
import 'package:gig_tasks/core/utils/snackbar_utils.dart';
import 'package:gig_tasks/core/utils/validation_utils.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_state.dart';
import 'package:uuid/uuid.dart';

class CreateEditTaskScreen extends StatefulWidget {
  final TaskEntity? task;

  const CreateEditTaskScreen({super.key, this.task});

  bool get isEditing => task != null;

  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDate == null) {
      SnackbarUtils.showError(context, AppStrings.dueDateRequired);
      return;
    }

  final authState = context.read<AuthBloc>().state;

String? userId;

if (authState is AuthAuthenticated) {
  userId = authState.user.id;
} else if (authState is AuthLoginSuccess) {
  userId = authState.user.id;
} else if (authState is AuthRegisterSuccess) {
  userId = authState.user.id;
}
if (userId == null) return;

    final now = DateTime.now();

    if (widget.isEditing) {
      final updated = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority,
        updatedAt: now,
      );
      context.read<TaskBloc>().add(TaskUpdateRequested(updated));
    } else {
        print("CREATING TASK FOR USER: $userId");
      final task = TaskEntity(
        id: const Uuid().v4(),
        userId: userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDate!,
        priority: _selectedPriority,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );
      context.read<TaskBloc>().add(TaskCreateRequested(task));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? AppStrings.editTask : AppStrings.newTask,
        ),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskCreateSuccess || state is TaskUpdateSuccess) {
            context.pop();
          }
          if (state is TaskFailureState) {
            SnackbarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is TaskOperationInProgress;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'Title'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      hintText: AppStrings.titleHint,
                    ),
                    validator: ValidationUtils.validateTaskTitle,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel(context, 'Description'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      hintText: AppStrings.descriptionHint,
                    ),
                    validator: ValidationUtils.validateTaskDescription,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel(context, 'Due Date'),
                  const SizedBox(height: 8),
                  _buildDatePicker(context),
                  const SizedBox(height: 20),
                  _buildSectionLabel(context, 'Priority'),
                  const SizedBox(height: 8),
                  _buildPrioritySelector(context),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textOnPrimary),
                            ),
                          )
                        : Text(widget.isEditing
                            ? AppStrings.updateTask
                            : AppStrings.saveTask),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: AppColors.textTertiary),
            const SizedBox(width: 12),
            Text(
              _selectedDate != null
                  ? TaskDateUtils.toDisplayDate(_selectedDate!)
                  : 'Select due date',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _selectedDate != null
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(BuildContext context) {
    return Row(
      children: TaskPriority.values.map((p) {
        final isSelected = _selectedPriority == p;
        final color = switch (p) {
          TaskPriority.high => AppColors.priorityHigh,
          TaskPriority.medium => AppColors.priorityMedium,
          TaskPriority.low => AppColors.priorityLow,
        };
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(
                right: p != TaskPriority.low ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? color : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    switch (p) {
                      TaskPriority.high =>
                        Icons.keyboard_double_arrow_up_rounded,
                      TaskPriority.medium => Icons.remove_rounded,
                      TaskPriority.low =>
                        Icons.keyboard_double_arrow_down_rounded,
                    },
                    color: isSelected ? AppColors.textOnPrimary : color,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? AppColors.textOnPrimary : color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}