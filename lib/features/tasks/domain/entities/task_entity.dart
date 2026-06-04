import 'package:equatable/equatable.dart';
import 'package:gig_tasks/core/constants/app_constants.dart';

enum TaskPriority {
  low,
  medium,
  high;

  int toInt() {
    switch (this) {
      case TaskPriority.low:
        return AppConstants.priorityLow;
      case TaskPriority.medium:
        return AppConstants.priorityMedium;
      case TaskPriority.high:
        return AppConstants.priorityHigh;
    }
  }

  static TaskPriority fromInt(int value) {
    switch (value) {
      case AppConstants.priorityMedium:
        return TaskPriority.medium;
      case AppConstants.priorityHigh:
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }

  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOverdue {
    if (isCompleted) return false;
    final today = DateTime.now();
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final now = DateTime(today.year, today.month, today.day);
    return due.isBefore(now);
  }

  bool get isDueToday {
    final today = DateTime.now();
    return dueDate.year == today.year &&
        dueDate.month == today.month &&
        dueDate.day == today.day;
  }

  TaskEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        dueDate,
        priority,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}