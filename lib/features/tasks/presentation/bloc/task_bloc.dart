import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/toggle_task_complete_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/watch_tasks_usecase.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_event.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final WatchTasksUseCase _watchTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final ToggleTaskCompleteUseCase _toggleTaskCompleteUseCase;

  StreamSubscription<dynamic>? _tasksSubscription;
  List<TaskEntity> _currentTasks = [];

  TaskBloc({
    required WatchTasksUseCase watchTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required ToggleTaskCompleteUseCase toggleTaskCompleteUseCase,
  })  : _watchTasksUseCase = watchTasksUseCase,
        _createTaskUseCase = createTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _toggleTaskCompleteUseCase = toggleTaskCompleteUseCase,
        super(const TaskInitial()) {
    on<TasksWatchStarted>(_onTasksWatchStarted);
    on<TasksUpdated>(_onTasksUpdated);
    on<TasksStreamErrored>(_onTasksStreamErrored);
    on<TaskCreateRequested>(_onTaskCreateRequested);
    on<TaskUpdateRequested>(_onTaskUpdateRequested);
    on<TaskDeleteRequested>(_onTaskDeleteRequested);
    on<TaskToggleCompleteRequested>(_onTaskToggleCompleteRequested);
  }

  void _onTasksWatchStarted(
    TasksWatchStarted event,
    Emitter<TaskState> emit,
  ) {
    emit(const TasksLoading());
    _tasksSubscription?.cancel();
    _tasksSubscription = _watchTasksUseCase(event.userId).listen(
      (result) => result.fold(
        (failure) => add(TasksStreamErrored(failure.message)),
        (tasks) => add(TasksUpdated(tasks)),
      ),
    );
  }

  void _onTasksUpdated(
    TasksUpdated event,
    Emitter<TaskState> emit,
  ) {
    _currentTasks = event.tasks;
    emit(TasksLoaded(_currentTasks));
  }

  void _onTasksStreamErrored(
    TasksStreamErrored event,
    Emitter<TaskState> emit,
  ) {
    emit(TaskFailureState(message: event.message, tasks: _currentTasks));
  }

  Future<void> _onTaskCreateRequested(
    TaskCreateRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskOperationInProgress(_currentTasks));
    final result = await _createTaskUseCase(CreateTaskParams(event.task));
    result.fold(
      (failure) => emit(
        TaskFailureState(message: failure.message, tasks: _currentTasks),
      ),
      (task) {
        // Stream will update _currentTasks via TasksUpdated,
        // but we emit success immediately for snackbar/navigation.
        emit(TaskCreateSuccess(task: task, tasks: _currentTasks));
      },
    );
  }

  Future<void> _onTaskUpdateRequested(
    TaskUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskOperationInProgress(_currentTasks));
    final result = await _updateTaskUseCase(UpdateTaskParams(event.task));
    result.fold(
      (failure) => emit(
        TaskFailureState(message: failure.message, tasks: _currentTasks),
      ),
      (task) => emit(TaskUpdateSuccess(task: task, tasks: _currentTasks)),
    );
  }

  Future<void> _onTaskDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskOperationInProgress(_currentTasks));
    final result = await _deleteTaskUseCase(event.taskId);
    result.fold(
      (failure) => emit(
        TaskFailureState(message: failure.message, tasks: _currentTasks),
      ),
      (_) => emit(TaskDeleteSuccess(_currentTasks)),
    );
  }

  Future<void> _onTaskToggleCompleteRequested(
    TaskToggleCompleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    final result = await _toggleTaskCompleteUseCase(event.task);
    result.fold(
      (failure) => emit(
        TaskFailureState(message: failure.message, tasks: _currentTasks),
      ),
      (task) => emit(TaskToggleSuccess(task: task, tasks: _currentTasks)),
    );
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}