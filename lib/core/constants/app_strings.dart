class AppStrings {
  const AppStrings._();

  // App
  static const String appName = 'GigTasks';
  static const String appTagline = 'Your daily jobs, organised.';

  // Auth screens
  static const String login = 'Log In';
  static const String register = 'Create Account';
  static const String logout = 'Log Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot password?';
  static const String noAccount = "Don't have an account? ";
  static const String haveAccount = 'Already have an account? ';
  static const String signUp = 'Sign up';
  static const String signIn = 'Sign in';
  static const String loggingIn = 'Logging in...';
  static const String registering = 'Creating account...';
  static const String logoutConfirmTitle = 'Log out?';
  static const String logoutConfirmBody = 'You will need to log in again to access your tasks.';
  static const String logoutConfirmButton = 'Log Out';

  // Validation
  static const String emailRequired = 'Email is required.';
  static const String emailInvalid = 'Enter a valid email address.';
  static const String passwordRequired = 'Password is required.';
  static const String passwordTooShort = 'Password must be at least 6 characters.';
  static const String passwordsDoNotMatch = 'Passwords do not match.';
  static const String titleRequired = 'Title is required.';
  static const String titleTooLong = 'Title must be under 120 characters.';
  static const String descriptionTooLong = 'Description must be under 500 characters.';
  static const String dueDateRequired = 'Due date is required.';

  // Task screens
  static const String tasks = 'Tasks';
  static const String myTasks = 'My Tasks';
  static const String newTask = 'New Task';
  static const String editTask = 'Edit Task';
  static const String taskDetail = 'Task Detail';
  static const String titleLabel = 'Title';
  static const String titleHint = 'e.g. Deliver package to warehouse';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Add any extra details...';
  static const String dueDateLabel = 'Due Date';
  static const String priorityLabel = 'Priority';
  static const String saveTask = 'Save Task';
  static const String updateTask = 'Update Task';
  static const String deleteTask = 'Delete Task';
  static const String markComplete = 'Mark Complete';
  static const String markIncomplete = 'Mark Incomplete';
  static const String deleteConfirmTitle = 'Delete task?';
  static const String deleteConfirmBody =
      'This task will be permanently deleted. This cannot be undone.';
  static const String deleteConfirmButton = 'Delete';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // Priority labels
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';

  // Filter / sort
  static const String filterAndSort = 'Filter & Sort';
  static const String filterByPriority = 'Priority';
  static const String filterByStatus = 'Status';
  static const String sortByDueDate = 'Due Date';
  static const String all = 'All';
  static const String completed = 'Completed';
  static const String pending = 'Pending';
  static const String searchHint = 'Search tasks...';
  static const String clearFilters = 'Clear Filters';

  // Empty / error states
  static const String emptyTasksTitle = 'No tasks yet';
  static const String emptyTasksBody = 'Tap + to add your first job for the day.';
  static const String emptyFilteredTitle = 'No matching tasks';
  static const String emptyFilteredBody = 'Try adjusting your filters or search term.';
  static const String errorTitle = 'Something went wrong';
  static const String retry = 'Retry';
  static const String errorLoadingTasks = 'Could not load tasks. Please try again.';

  // Snackbar messages
  static const String taskCreated = 'Task created successfully.';
  static const String taskUpdated = 'Task updated successfully.';
  static const String taskDeleted = 'Task deleted.';
  static const String taskCompleted = 'Task marked as complete.';
  static const String taskReopened = 'Task marked as incomplete.';
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created. Welcome!';

  // Due date display
  static const String overdue = 'Overdue';
  static const String dueToday = 'Due today';
  static const String dueTomorrow = 'Due tomorrow';
  static const String dueInDays = 'Due in {n} days';
  static const String dueDatePast = '{n} days ago';

  // Profile
  static const String profile = 'Profile';
  static const String signedInAs = 'Signed in as';
}