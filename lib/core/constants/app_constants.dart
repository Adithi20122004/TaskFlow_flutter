class AppConstants {
  const AppConstants._();

  // Firestore
  static const String tasksCollection = 'tasks';

  // Task field keys (Firestore document field names)
  static const String fieldId = 'id';
  static const String fieldUserId = 'userId';
  static const String fieldTitle = 'title';
  static const String fieldDescription = 'description';
  static const String fieldDueDate = 'dueDate';
  static const String fieldPriority = 'priority';
  static const String fieldIsCompleted = 'isCompleted';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  // Pagination
  static const int taskPageSize = 20;

  // Validation
  static const int taskTitleMaxLength = 120;
  static const int taskDescriptionMaxLength = 500;
  static const int passwordMinLength = 6;

  // Animation durations (ms)
  static const int shortAnimationMs = 200;
  static const int mediumAnimationMs = 350;
  static const int longAnimationMs = 500;

  // Snackbar duration (seconds)
  static const int snackbarDurationSeconds = 3;

  // Priority levels (stored as int in Firestore)
  static const int priorityLow = 0;
  static const int priorityMedium = 1;
  static const int priorityHigh = 2;
}