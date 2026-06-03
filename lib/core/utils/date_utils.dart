import 'package:intl/intl.dart';

class TaskDateUtils {
  const TaskDateUtils._();

  static final DateFormat _displayFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _shortFormat = DateFormat('MMM d');
  static final DateFormat _firestoreFormat = DateFormat('yyyy-MM-dd');

  /// Returns a human-readable relative label for task cards.
  static String toRelativeLabel(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;

    if (diff < 0) {
      final days = diff.abs();
      return days == 1 ? '1 day overdue' : '$days days overdue';
    }
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    if (diff <= 7) return 'Due in $diff days';
    return 'Due ${_shortFormat.format(dueDate)}';
  }

  /// Returns true if the due date has passed.
  static bool isOverdue(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today);
  }

  /// Returns true if the task is due today.
  static bool isDueToday(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due == today;
  }

  /// Returns true if the task is due within the next 24 hours.
  static bool isDueSoon(DateTime dueDate) {
    final now = DateTime.now();
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = due.difference(today).inDays;
    return diff == 0 || diff == 1;
  }

  /// Full formatted date for the detail screen.
  static String toDisplayDate(DateTime date) =>
      _displayFormat.format(date);

  /// Short formatted date.
  static String toShortDate(DateTime date) =>
      _shortFormat.format(date);

  /// Time only.
  static String toTime(DateTime date) =>
      _timeFormat.format(date);

  /// ISO-style date for Firestore storage (YYYY-MM-DD).
  static String toStorageString(DateTime date) =>
      _firestoreFormat.format(date);

  /// Parse a storage string back to DateTime.
  static DateTime fromStorageString(String s) =>
      _firestoreFormat.parse(s);

  /// Returns the color-coded urgency for a due date.
  /// 0 = normal, 1 = soon (today/tomorrow), 2 = overdue
  static int urgencyLevel(DateTime dueDate) {
    if (isOverdue(dueDate)) return 2;
    if (isDueSoon(dueDate)) return 1;
    return 0;
  }
}