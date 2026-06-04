import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_tasks/core/constants/app_constants.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.priority,
    required super.isCompleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      userId: data[AppConstants.fieldUserId] as String? ?? '',
      title: data[AppConstants.fieldTitle] as String? ?? '',
      description: data[AppConstants.fieldDescription] as String? ?? '',
      dueDate: (data[AppConstants.fieldDueDate] as Timestamp?)?.toDate() ??
          DateTime.now(),
      priority: TaskPriority.fromInt(
        data[AppConstants.fieldPriority] as int? ?? 0,
      ),
      isCompleted: data[AppConstants.fieldIsCompleted] as bool? ?? false,
      createdAt: (data[AppConstants.fieldCreatedAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
      updatedAt: (data[AppConstants.fieldUpdatedAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AppConstants.fieldUserId: userId,
      AppConstants.fieldTitle: title,
      AppConstants.fieldDescription: description,
      AppConstants.fieldDueDate: Timestamp.fromDate(dueDate),
      AppConstants.fieldPriority: priority.toInt(),
      AppConstants.fieldIsCompleted: isCompleted,
      AppConstants.fieldCreatedAt: Timestamp.fromDate(createdAt),
      AppConstants.fieldUpdatedAt: Timestamp.fromDate(updatedAt),
    };
  }

  TaskEntity toEntity() => TaskEntity(
        id: id,
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        isCompleted: isCompleted,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}